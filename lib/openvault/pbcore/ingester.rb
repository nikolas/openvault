require 'openvault'
require 'openvault/pbcore/description_document_wrapper'

module Openvault::Pbcore
  class Ingester
    attr_accessor :xml, :pids, :failed 

    def initialize(xml=nil)
      @xml = xml
      @pids = []
      @failed = []
      @relation_builder = AssetRelationshipBuilder.new()
    end

    def find_by_pbcore_ids pbcore_ids
      pbcore_ids = Array.wrap(pbcore_ids)
      ActiveFedora::Base.find("all_ids_tesim" => pbcore_ids)
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

    def ingest!
      with_desc_docs do |doc|
        doc.model.save! 
        self.pids << doc.model.pid
      end

      relate_pids!
    end

    def ingest 
      with_desc_docs do |doc|
        begin
          doc.model.save && (self.pids << doc.model.pid)
        rescue Exception => e
          @failed << doc
          Rails.logger.error(e.message)
        end
      end

      Rails.logger.info "The following pids failed to load: #{failed.join('\n')}" unless failed.empty?

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
