require 'artesia/datastreams'
require 'artesia/datastreams/uois'

class Datastream::UOIS < ActiveFedora::OmDatastream

  include Openvault::Datastreams
  include Artesia::Datastreams::UOIS

  set_terminology do |t|
    t.root(:path => "UOIS")
    add_uois_terminology t
  end

  # Returns true if XML describes a series record.
  # It is a series record iff:
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
  # NOTE: Sometimes a video or audio record will also serve as the program record.
  def is_program?
    self.wgbh_title.title_type.include?("Program") && !(self.is_series? || self.is_collection? || self.is_transcript? || self.is_image?)
  end

  # Returns true if XML describes a collection record.
  # It is a collection record iff:
  #  - wgbh_title.title_type contains "Collection"
  def is_collection?
    self.wgbh_title.title_type.include?("Collection")
  end

  # Returns true if XML describes a video.
  # It is a video record iff:
  #   - The wgbh_type.media_type contains "Moving Image" and nothing else.
  def is_video?
    (self.wgbh_type.media_type == ["Moving Image"])
  end

  # Returns tue if XML describes a transcript
  # It is a transcript record iff:
  #   - wgbh_type.item_type contains at least one value that begins with "Transcript"
  def is_transcript?
    (self.wgbh_type.item_type.grep(/^Transcript/).count > 0)
  end

  # Returns true if XML describes an image.
  # It is an image record iff:
  #   - wgbh_type.item_type contains "Static Image" and nothing else.
  #   - OR the master_obj_mime_type (from root node) contains a value that begins with "image".
  def is_image?
    (self.wgbh_type.item_type == ['Static Image']) || (self.master_obj_mime_type.grep(/^image/).count > 0)
  end

  # Returns true if XML describes audio.
  # It is an audio record iff:
  #   - wgbh_type.media_type contains "Audio" and nothing else.
  def is_audio?
    (self.wgbh_type.media_type == ["Audio"])
  end

  class << self
    # Returns a default xml doc for the datastream.
    def xml_template
      Nokogiri::XML.parse("<UOIS/>")
    end
  end
  
end