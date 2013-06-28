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

  def is_series?
    
  end

  def is_program?
    
  end

  def is_collection?
    
  end

  def is_video?
    
  end

  def is_transcript?
    
  end

  def is_image?
    
  end

  def is_audio?
    
  end

  class << self
    def xml_template
      Nokogiri::XML.parse("<UOIS/>")
    end  
  end
  
end