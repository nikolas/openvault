require 'artesia/datastreams/uois'

class Datastream::UOIS < ActiveFedora::OmDatastream

  include Artesia::Datastreams::UOIS

  set_terminology do |t|
    t.root(:path => "UOIS")
    add_uois_terminology t
  end

  def set_xml(xml)
    self.ng_xml = Nokogiri::XML(xml) do |config|
      config.strict
    end
  end

  class << self
    def xml_template
      Nokogiri::XML.parse("<UOIS/>")
    end  
  end
  
end