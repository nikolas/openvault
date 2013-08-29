require 'nokogiri'

module Openvault
  class << self
    attr_accessor :ng_parse_options

    def ng_parse_options= val
      raise "ng_parse_options expects an integer, #{val.class} given" unless val.kind_of? Integer
      @ng_parse_options = val
    end

    ##
    # Convenience method for using self.ng_parse_options when parsing xml with Nokogiri
    # Usage:
    #   Openvault::XML(xml_string)
    #   => Nokogiri::XML::Document
    def XML thing, url = nil, encoding = nil, options = nil, &block
      options ||= self.ng_parse_options
      Nokogiri::XML::Document.parse(thing, url, encoding, options, &block)
    end
  end

  # Default Nokogiri parse options for Openvault.
  self.ng_parse_options = Nokogiri::XML::ParseOptions::STRICT
end