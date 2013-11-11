require 'openvault'

module Openvault::Pbcore
  class << self

    # Uses values from <pbcoreIdentifier> nodes to check
    # Fedora for existing instances of models that contain
    # those values. If not found, returns a new model, and assigns
    # the pbcore datastream to it.
    def get_model_for pbcore_desc_doc

      # Look for existing recod based on values from <pbcoreIdentifier>
      model_class = get_model_class_for pbcore_desc_doc

      # only run query if there are actually some pbcore ids.. will error otherwise.
      # Fix pending in https://github.com/projecthydra/active_fedora/pull/273.
      # Once fixed can eliminate if!pbcore_desc_doc.all_ids.empty?
      if !pbcore_desc_doc.all_ids.empty?
        found = model_class.find({"pbcoreDescriptionDocument_all_ids_tesim" => pbcore_desc_doc.all_ids})
        if !found.empty?
          return found.first
        end
      end

      # If we didn't find anything, return
      return get_new_model_for pbcore_desc_doc
    end

    def get_new_model_for pbcore_desc_doc
      model = self.get_model_class_for(pbcore_desc_doc).new
      model.pbcore.ng_xml = pbcore_desc_doc.ng_xml
      model
    end

    # Returns appropriate ActiveFedora model for the pbcore datastream
    def get_model_class_for pbcore_desc_doc

      # First figure out what the xml represents. If it is more than one
      # model, then relate them afterward.
      if self.is_series? pbcore_desc_doc
        model_class= Series
      elsif self.is_program? pbcore_desc_doc
        model_class= Program
      elsif self.is_video? pbcore_desc_doc
        model_class= Video
      elsif self.is_image? pbcore_desc_doc
        model_class= Image
      elsif self.is_audio? pbcore_desc_doc
        model_class= Audio
      elsif self.is_transcript? pbcore_desc_doc
        model_class= Transcript
      else
        model_class= OpenvaultAsset
      end

      model_class
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

      # Now that all the models are saved, relate them.
      pids.each do |pid|
        model = OpenvaultAsset.find pid, :cast => true
        model.create_relations_from_pbcore!
      end

      pids
    end

    def is_from_mars? pbcore_desc_doc
      raise 'needs code!'
    end
  end
end