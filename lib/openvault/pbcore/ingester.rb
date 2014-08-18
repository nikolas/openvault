require 'openvault'
require 'openvault/pbcore/description_document_wrapper'

module Openvault::Pbcore
  class Ingester
    attr_accessor :xml, :pids, :policy

    POLICIES = [
      :skip_if_exists,
      :replace_if_exists,
      :update_if_exists
    ]

    def initialize(xml=nil)
      @xml = xml
      @pids = []
      @relation_builder = AssetRelationshipBuilder.new()

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

    def find_by_pbcore_ids pbcore_ids
      pbcore_ids = Array.wrap(pbcore_ids)
      ActiveFedora::Base.find({"all_ids_tesim" => pbcore_ids, cast: true})
    end

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

    def policy=(policy)
      raise "#{policy.inspect} is not a valid policy. Use one of these: #{POLICIES.map {|p| p.inspect }.join(', ')}." unless POLICIES.include? policy
      @policy = policy
    end

    def skip_existing(doc)
      Rails.logger.info("#{doc.model.class}(pid=#{doc.model.pid}) found containing #{doc.model.pbcore.all_ids.inspect}. Skipping due to policy #{policy.inspect}...")
    end

    def replace_existing(doc)
      Rails.logger.info("#{doc.model.class}(pid=#{doc.model.pid}) found containing #{doc.model.pbcore.all_ids.inspect}. Replacing due to policy #{policy.inspect}...")
      doc.model.delete
      doc.model(:reset_from_pbcore => true).save
      pids << doc.model.pid
    end
    
    def update_existing(doc)
      Rails.logger.info("#{doc.model.class}(pid=#{doc.model.pid}) found containing #{doc.doc.all_ids.inspect}. Updating due to policy #{policy.inspect}...")
      doc.model.save
      pids << doc.model.pid
    end

    def ingest
      ingest!(continue_on_error: true)
    end

    def ingest!(opts={})

      Rails.logger.info("#{ng_pbcore_desc_docs.count} records identified.")
      with_desc_docs do |doc|
        
        begin
          # If the record exists
          if doc.model.persisted?
            case @policy
            when :skip_if_exists
              skip_existing(doc)
            when :update_if_exists
              update_existing(doc)
            when :replace_if_exists
              replace_existing(doc)
            end
          else
            # Record doesn't exist.. just insert it.
            doc.model.save && (self.pids << doc.model.pid)  
          end
        rescue Exception => e
          if opts[:continue_on_error]
            Rails.logger.error(e.message)
            Rails.logger.info(e.message)
          else
            raise e
          end
        end
      end

      relate_pids
    end

    def relate_pids!
      pids.each do |pid|
        @relation_builder.asset = OpenvaultAsset.find(pid, cast: true)
        @relation_builder.relate
      end
    end

    def relate_pids
      pids.each do |pid|
        begin
          @relation_builder.asset = OpenvaultAsset.find(pid, cast: true)
          @relation_builder.relate
        rescue Exception => e
          Rails.logger.error("** Error: #{e.message}\n **** Backtrace: #{e.backtrace}")
        end
      end
    end
  end
end
