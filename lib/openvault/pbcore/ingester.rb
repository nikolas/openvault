require 'openvault'

module Openvault::Pbcore
  class Ingester

    POLICIES = [
      :skip_if_exists,
      :replace_if_exists,
      :update_if_exists
    ]

    attr_reader :xml, :pids, :policy

    def initialize(xml=nil)
      @xml = xml
      @pids = []
      @policy = :skip_if_exists

    end

    def logger=(logger)
      raise(ArgumentError, "First argument must be an instance of Logger, but #{logger.class} was given") unless logger.is_a? Logger
      @logger = logger
    end

    def logger
      unless @logger
        @logger = Logger.new(STDOUT)
        @logger.level = 1
      end
      @logger
    end

    def policy=(policy)
      raise "#{policy.inspect} is not a valid policy. Use one of these: #{POLICIES.map {|p| p.inspect }.join(', ')}." unless POLICIES.include? policy
      @policy = policy
    end

    def ingest
      ingest!(continue_on_error: true)
      ingest_summary
    end

    def ingest!(opts={})

      logger.info("#{ng_pbcore_desc_docs.count} records identified.")
      @inserted_records = 0
      @skipped_records = 0
      @updated_records = 0
      @replaced_records = 0
      @failed_records = 0
      @unsupported_assoc = 0

      pbcore_desc_docs.each do |pbcore_desc_doc|

        updater = OpenvaultAssetUpdater.new(pbcore_desc_doc)
        existing_ov_asset = updater.existing_openvault_asset
        updated_ov_asset = updater.updated_openvault_asset

        
        begin
          # If the record exists
          if !existing_ov_asset.nil?
            case @policy
            when :skip_if_exists
              skip_existing(existing_ov_asset)
              @skipped_records += 1
            when :update_if_exists
              if update_existing(updated_ov_asset, existing_ov_asset)
                @updated_records += 1
              end
              
            when :replace_if_exists
              if replace_existing(updated_ov_asset, existing_ov_asset)
                @replaced_records += 1
              end
            end
          else
            # Record doesn't exist.. just insert it.
            updated_ov_asset.save && (self.pids << updated_ov_asset.pid)
            @inserted_records += 1
          end

          # Relate the newly ingested asset to anything already in Fedora that it might be related to, unless we skippe them altogether.
          AssetRelationshipBuilder.new(updated_ov_asset).establish_relationships_in_fedora unless @policy == :skip_if_exists

          # logger.info "Successfully ingested #{ov_asset.class}, PID: #{ov_asset.pid}, pbcoreIdentifiers: #{ov_asset.pbcore.all_ids}"
        rescue StandardError => e
          if opts[:continue_on_error]
            if e.is_a? AssetRelationshipBuilder::UnhandledRelationType
              @unsupported_assoc += 1
              logger.info "Unable to establish relationships in Fedora for #{updated_ov_asset.pbcore.all_ids}"
            else
              @failed_records += 1
              logger.info "Unable to ingest #{updated_ov_asset.pbcore.all_ids}"
            end
            logger.error(e.inspect)
          else
            raise e
          end
        end

        begin

        rescue StandardError => e
          if opts[:continue_on_error]
            @failed_associations += 1
            logger.info "Unable to establish relationship between Fedora objects"
            logger.error(e.inspect)
          else
            raise e
          end
        end
      end
    end


    protected


    def ng_xml
      @namespaced_xml ||= Openvault::XML(xml)
      @ng_xml ||= @namespaced_xml.remove_namespaces!
    end

    def ng_pbcore_desc_docs
      @ng_pbcore_desc_docs ||= ng_xml.xpath('//pbcoreDescriptionDocument')
    end

    def pbcore_desc_docs
      ng_pbcore_desc_docs.map do |ng_pbcore_desc_doc|
        PbcoreDescDoc.new.tap do |pbcore_desc_doc|
          pbcore_desc_doc.ng_xml = ng_pbcore_desc_doc
        end
      end
    end

    def ingest_summary
      logger.info "#{@inserted_records} were inserted."
      logger.info "#{@skipped_records} were skipped."
      logger.info "#{@updated_records} were updated."
      logger.info "#{@replaced_records} were replaced."
      logger.info "#{@failed_records} were unable to be ingested."
      logger.info "#{@unsupported_assoc} have associations specified in metadata that are not supported."
    end

    def skip_existing(existing_ov_asset)
      logger.info("#{existing_ov_asset.class}(pid=#{existing_ov_asset.pid}) found containing #{existing_ov_asset.pbcore.all_ids.inspect}. Skipping due to policy #{policy.inspect}...")
      pids
    end

    def replace_existing(updated_ov_asset, existing_ov_asset)
      logger.info("#{existing_ov_asset.class}(pid=#{existing_ov_asset.pid}) found containing #{existing_ov_asset.pbcore.all_ids.inspect}. Updating with #{updated_ov_asset.class}(pid=#{updated_ov_asset.pid}) due to policy #{policy.inspect}...")
      return false unless updated_ov_asset.save
      if existing_ov_asset.pid != updated_ov_asset.pid
        existing_ov_asset.delete
      end
      pids << updated_ov_asset.pid
    end
    
    def update_existing(updated_ov_asset, existing_ov_asset)
      if (existing_ov_asset.pid != updated_ov_asset.pid)
        raise "Cannot update #{existing_ov_asset.class}(pid=#{existing_ov_asset.pid}). Pbcore metadata requires that the asset be reclassified as #{updated_ov_asset.class}. Re-ingest using :replace_if_exists flag to replace existing asset with a new asset. WARNING: THIS WILL CHANGE THE PID FOR THE REPLACED ASSET!"
      end

      logger.info("#{existing_ov_asset.class}(pid=#{existing_ov_asset.pid}) found containing #{existing_ov_asset.pbcore.all_ids.inspect}. Updating due to policy #{policy.inspect}...")
      return false unless updated_ov_asset.save
      pids << updated_ov_asset.pid
    end
  end
end
