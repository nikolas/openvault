require 'openvault'

module Openvault
  class Ingester
    class Pbcore

      def self.ingest!(xml, depositor)
        ng_xml = Openvault::XML(xml)

        # grab the first listed namespace. There should be only one, and it is probably "xmlns" => "http://www.pbcore.org/PBCore/PBCoreNamespace.html"
        namespace = ng_xml.namespaces.first
        ns_name = namespace[0]
        ns_location = namespace[1]

        ingested = []

        # get the pbcoreDescriptionDocument nodes with xpath and namespaces.
        ng_xml.xpath("//#{ns_name}:pbcoreDescriptionDocument", ns_name => ns_location).each do |ng_xml_pbcoreDescriptionDocument|
          ov = OpenvaultAsset.new
          ov.pbcore.ng_xml = ng_xml_pbcoreDescriptionDocument
          ov.apply_depositor_metadata depositor
          ov.save!
          ingested << ov
        end
        ingested
      end
    end
  end
end