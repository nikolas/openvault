module Openvault
  module Datastreams

    extend ActiveSupport::Concern

    def set_xml(xml, opts={})
      opts[:encoding] = self.class.get_encoding(xml) unless opts[:encoding]
      self.ng_xml = Nokogiri::XML(xml, nil, opts[:encoding]) do |config|
        config.strict
      end
    end
    
    module ClassMethods
      def get_encoding(xml)
          # First check the 'encoding' attribute on root node of xml.
          encoding = Nokogiri::XML(xml).encoding
          # Default to encoding of string according to ruby.
          encoding ||= xml.encoding.to_s
      end
    end

    # This allows calling methods from ClassMethods from the module directly, e.g. Openvault::Datastream.get_encoding.
    extend ClassMethods
  end
end