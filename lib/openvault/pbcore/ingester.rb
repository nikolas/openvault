module Openvault::Pbcore
  class Ingester
    attr_accessor :xml, :pids 

    def initialize(xml)
      @xml = xml
      @pids = []
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
        wrapper = DescriptionDocumentWrapper.new
        wrapper.doc = PbcoreDescDoc.new.tap do |doc|
                        doc.ng_xml = ng_pbcore_desc_doc
                      end
        
        yield wrapper
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
          Rails.logger.error(e.message)
        end
      end

      relate_pids
    end

    def relate_pids!
      pids.each do |pid|
        OpenvaultAsset.find(pid, cast: true).try(:create_relations_from_pbcore!)
      end
    end

    def relate_pids
      pids.each do |pid|
        begin
          OpenvaultAsset.find(pid, cast: true).try(:create_relations_from_pbcore!)
        rescue Exception => e
          Rails.logger.error("** Error: #{e.message}")
        end
      end
    end
  end
end
