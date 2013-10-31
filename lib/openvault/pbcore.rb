require 'openvault'

module Openvault::Pbcore
  class << self

    # Returns appropriate ActiveFedora model for the pbcore datastream
    def get_model_for pbcore_desc_doc

      # First figure out what the xml represents. If it is more than one
      # model, then relate them afterward.
      if self.is_series? pbcore_desc_doc
        model = Series.new
      elsif self.is_program? pbcore_desc_doc
        model = Program.new
      elsif self.is_video? pbcore_desc_doc
        model = Video.new
      elsif self.is_image? pbcore_desc_doc
        model = Image.new
      elsif self.is_audio? pbcore_desc_doc
        model = Audio.new
      elsif self.is_transcript? pbcore_desc_doc
        model = Transcript.new
      else
        model = OpenvaultAsset.new
      end


      model.pbcore.ng_xml = pbcore_desc_doc.ng_xml
      model
    end

    # Returns true if PbcoreDescDoc datastream describes a Series record.
    # It is a Series if:
    #   - it has a series title
    #   - it has does not have a program title
    #   - it does not have any media types
    def is_series? pbcore_desc_doc
      !pbcore_desc_doc.series_title.empty? && pbcore_desc_doc.program_title.empty? && pbcore_desc_doc.instantiations.media_type.empty?
    end

    # Returns true if PbcoreDescDoc datastream describes a Program record
    # It is a Program if:
    #   - it has a program title
    #   - it does not have any media types
    def is_program? pbcore_desc_doc
      !pbcore_desc_doc.program_title.empty? && pbcore_desc_doc.instantiations.media_type.empty?
    end

    # Returns true if PbcoreDescDoc datastream describes a Program record
    # It is a Program if:
    #   - the media type is "moving image"
    def is_video? pbcore_desc_doc
      media_type = pbcore_desc_doc.instantiations(0).media_type.first
      !media_type.nil? && media_type.downcase ==  "moving image"
    end

    # Returns true if PbcoreDescDoc datastream describes a Program record
    # It is a Program if:
    #   - the media type is "static image"
    #   - OR
    #   - the asset type contains the string with "photograph"
    def is_image? pbcore_desc_doc
      media_type = pbcore_desc_doc.instantiations(0).media_type.first
      asset_type = pbcore_desc_doc.asset_type.first
      (!media_type.nil? && media_type.downcase == "static image") || (!asset_type.nil? && asset_type.downcase.include?("photograph"))
    end

    # Returns true if PbcoreDescDoc datastream describes a Program record
    # It is a Program if:
    #   - the media type is "audio"
    def is_audio? pbcore_desc_doc
      media_type = pbcore_desc_doc.instantiations(0).media_type.first
      !media_type.nil? && media_type.downcase == "audio"
    end

    # Returns true if PbcoreDescDoc datastream describes a Program record
    # It is a Program if:
    #   - the asset type contains the string "transcript"
    def is_transcript? pbcore_desc_doc
      asset_type = pbcore_desc_doc.asset_type.first
      !asset_type.nil? && asset_type.downcase.include?('transcript')
    end


    def ingest! xml
      pids = []
      ng_xml = Openvault::XML(xml)
      ng_xml.remove_namespaces!
      ng_pbcore_desc_docs = ng_xml.xpath('//pbcoreDescriptionDocument')
      ng_pbcore_desc_docs.each do |ng_pbcore_desc_doc|
        pbcore_desc_doc = PbcoreDescDoc.new
        pbcore_desc_doc.ng_xml = ng_pbcore_desc_doc
        model = self.get_model_for pbcore_desc_doc
        model.save!
        pids << model.pid
      end
      pids
    end
  end
end