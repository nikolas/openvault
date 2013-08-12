module Openvault
  module Datastream

    extend ActiveSupport::Concern

    def set_xml(xml, opts={})
      opts[:encoding] ||= Nokogiri::XML(xml).encoding ||= xml.encoding.to_s
      self.ng_xml = Nokogiri::XML(xml, nil, opts[:encoding]) do |config|
        config.strict
      end
    end
  end
end