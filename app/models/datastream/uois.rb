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

  # Returns true if XML describes a series record.
  # It is a series record if and only if:
  #   - It has exactly one value for wgbh_title.title_type and that value is "Series"
  #   - Does NOT exclusively describe an image
  def is_series?
    self.wgbh_title.title_type == ["Series"] && !self.is_image?
  end

  # Returns true if XML descrbes a program record.
  # It is a program record if:
  #   - It has "Program" exists within wgbh_title.title_type (there may be more than just "Program")
  #   - Does NOT exclusively describing any of the following:
  #     - series record
  #     - collection record
  #     - image record (although a program record may have an image within it, it is not an image record in and of itself)
  #     - transcript record
  #     - audio record
  #    
  def is_program?
    self.wgbh_title.title_type.include?("Program") && !(self.is_series? || self.is_collection? || self.is_transcript? || self.is_image? || self.is_audio? || self.is_video_clip?)
  end

  # Returns true if XML describes a collection record.
  # It is a collection record if and only if:
  #  * "Collection" is one of the values in wgbh_title.title_type
  def is_collection?
    self.wgbh_title.title_type.include?("Collection")
  end

  def is_video?
    self.wgbh_type.media_type == ["Moving Image"]
  end

  def is_transcript?
    self.wgbh_type.item_type.grep(/^Transcript/).count > 0
  end

  def is_image?
    self.wgbh_type.item_type == ['Static Image'] || self.master_obj_mime_type == ['image/jpeg']
  end

  def is_audio?
    false
  end

  def is_video_clip?
    # TODO: Are there other types that we need to check for here?
    self.wgbh_title.title_type.include?("Clip") || (self.wgbh_title.title_type.grep(/Element2/).count > 0)
  end

  class << self
    def xml_template
      Nokogiri::XML.parse("<UOIS/>")
    end  
  end
  
end