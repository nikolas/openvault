require 'openvault'

module Openvault::Pbcore
  class << self

    def find_by_pbcore_ids pbcore_ids
      pbcore_ids = Array.wrap(pbcore_ids)
      ActiveFedora::Base.find("all_ids_tesim" => pbcore_ids)
    end


    # Uses values from <pbcoreIdentifier> nodes to check
    # Fedora for existing instances of models that contain
    # those values. If not found, returns a new model, and assigns
    # the pbcore datastream to it.
    def get_model_for pbcore_desc_doc

      # only run query if there are actually some pbcore ids.. will error otherwise.
      # Fix pending in https://github.com/projecthydra/active_fedora/pull/273.
      # Once fixed can eliminate if!pbcore_desc_doc.all_ids.empty?
      if !pbcore_desc_doc.all_ids.empty?
        found = ActiveFedora::Base.find({"all_ids_tesim" => pbcore_desc_doc.all_ids})
        if !found.empty?
          return found.first
        end
      end

      # If we didn't find anything, return a new model
      return get_new_model_for pbcore_desc_doc
    end

    def get_new_model_for pbcore_desc_doc
      model = self.get_model_class_for(pbcore_desc_doc).new
      model.pbcore.ng_xml = pbcore_desc_doc.ng_xml
      model
    end

    # Returns appropriate ActiveFedora model class for the pbcore datastream
    def get_model_class_for pbcore_desc_doc

      klass = if self.is_series? pbcore_desc_doc
        Series
      elsif self.is_program? pbcore_desc_doc
        Program
      elsif self.is_video? pbcore_desc_doc
        Video
      elsif self.is_image? pbcore_desc_doc
        Image
      elsif self.is_audio? pbcore_desc_doc
        Audio
      elsif self.is_transcript? pbcore_desc_doc
        Transcript
      else
        nil
      end

      raise "Hey, I don't know which model to use for this pbcore." if klass.nil?
      klass
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
    #   - it does not have other title types that would indicate a record other than a program title.
    #     NOTE: The presence of any of these other titles is enough to indicate that the record is *not* a program record.
    #     NOTE: A program record may have title types other than "Program", namely it may also have titles of type "Series" and "Episode",
    #       but for our consideration, it is still a Program record.
    def is_program? pbcore_desc_doc

      # get all of the title types that would indicate a record *other* than a Program record
      non_program_titles = pbcore_desc_doc.titles_by_type.keys.select do |title_type|
        !!(title_type =~ /^Element/) || !!(title_type =~ /^Item/) || !!(title_type =~ /^Segment/) || !!(title_type =~ /^Clip/)  
      end

      !pbcore_desc_doc.program_title.empty? && non_program_titles.empty? && !is_image?(pbcore_desc_doc)
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

    def ingest xml
      begin
        self.ingest!(xml)
      rescue Exception => e
        Rails.logger.error(e.message)
      end
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