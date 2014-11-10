require 'openvault'
require 'openvault/pbcore/description_document_wrapper'

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

      with_desc_docs do |doc_wrapper|
        
        begin
          # If the record exists
          if doc_wrapper.model.persisted?
            case @policy
            when :skip_if_exists
              skip_existing(doc_wrapper)
              @skipped_records += 1
            when :update_if_exists
              update_existing(doc_wrapper)
              @updated_records += 1
            when :replace_if_exists
              replace_existing(doc_wrapper)
              @replaced_records += 1
            end
          else
            # Record doesn't exist.. just insert it.
            doc_wrapper.model.save && (self.pids << doc_wrapper.model.pid) 
            @inserted_records += 1
          end

          # Relate the newly ingested asset to anything already in Fedora that it might be related to.
          AssetRelationshipBuilder.new(doc_wrapper.model).establish_relationships_in_fedora

          logger.info "Successfully ingested #{doc_wrapper.doc.all_ids}."
        rescue StandardError => e
          if opts[:continue_on_error]
            @failed_records += 1
            logger.info "Unable to ingest #{doc_wrapper.doc.all_ids}."
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

    def with_desc_docs &block
      ng_pbcore_desc_docs.each do |ng_pbcore_desc_doc|
        doc = PbcoreDescDoc.new.tap do |doc|
                doc.ng_xml = ng_pbcore_desc_doc
              end
        yield DescriptionDocumentWrapper.new(doc)
      end
    end

    def ingest_summary
      logger.info "#{@inserted_records} were inserted."
      logger.info "#{@skipped_records} were skipped."
      logger.info "#{@updated_records} were updated."
      logger.info "#{@replaced_records} were replaced."
      logger.info "#{@failed_records} were unable to be ingested."
    end

    def skip_existing(doc)
      logger.info("#{doc.model.class}(pid=#{doc.model.pid}) found containing #{doc.model.pbcore.all_ids.inspect}. Skipping due to policy #{policy.inspect}...")
    end

    def replace_existing(doc)
      logger.info("#{doc.model.class}(pid=#{doc.model.pid}) found containing #{doc.model.pbcore.all_ids.inspect}. Replacing due to policy #{policy.inspect}...")
      doc.model.delete
      doc.model(:reset_from_pbcore => true).save
      pids << doc.model.pid
    end
    
    def update_existing(doc)
      logger.info("#{doc.model.class}(pid=#{doc.model.pid}) found containing #{doc.doc.all_ids.inspect}. Updating due to policy #{policy.inspect}...")
      doc.model.save
      pids << doc.model.pid
    end

  end
end
