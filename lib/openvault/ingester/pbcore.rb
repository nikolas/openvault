require 'openvault'

module Openvault
  class Ingester
    class Pbcore

      def self.ingest!(xml)
        ingested = []
        self.description_documents_from_xml(xml).each do |ng_xml_pbcoreDescriptionDocument|
          ov = OpenvaultAsset.new
          ov.pbcore.ng_xml = ng_xml_pbcoreDescriptionDocument
          ov.save!
          ingested << ov
        end

        # return ingested OpenvaultAsset models
        ingested
      end

      def self.description_documents_from_xml(xml)
        ng_xml = Openvault::XML(xml)

        # grab the first listed namespace. There should be only one, and it is probably "xmlns" => "http://www.pbcore.org/PBCore/PBCoreNamespace.html"
        namespace = ng_xml.namespaces.first
        ns_name = namespace[0]
        ns_location = namespace[1]
        ng_xml.xpath("//#{ns_name}:pbcoreDescriptionDocument", ns_name => ns_location)
      end
    end
  end
end