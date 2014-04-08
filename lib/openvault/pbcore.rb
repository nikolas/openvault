require 'openvault'

module Openvault::Pbcore
  class DescriptionDocumentWrapper 
    attr_accessor :doc
 
    def initialize(*doc)
      @doc = doc
    end
    
    # Returns appropriate ActiveFedora model class for the pbcore datastream
    def model_class
      %w(series program transcript video audio image).each do |type| 
        return Kernel.const_get(type.classify) if (send("is_#{type}?".to_s))
      end
      raise "Hey, I don't know which model to use for this pbcore: #{self}" 
    end 

    def new_model 
      model_class.new.tap do |model|
        model.pbcore.ng_xml = @doc.ng_xml
      end
    end

    # Uses values from <pbcoreIdentifier> nodes to check
    # Fedora for existing instances of models that contain
    # those values. If not found, returns a new model, and assigns
    # the pbcore datastream to it.
    def model 
      @model ||= fedora_models.first || new_model
    end

    def fedora_models
      @fedora_models ||= ActiveFedora::Base.find({"all_ids_tesim" => doc.all_ids})
    end

    def is_from_mars?
      raise 'Unless you implement me, I will report that I am from venus!'
    end

    # Returns true if PbcoreDescDoc datastream describes a Series record.
    # It is a Series if:
    #   - it has a series title
    #   - it has does not have a program title
    #   - it does not have any media types
    def is_series? 
      !doc.series_title.empty? && doc.program_title.empty? && doc.instantiations.media_type.empty?
    end

    # Returns true if PbcoreDescDoc datastream describes a Program record
    # It is a Program if:
    #   - it has a program title
    #   - it does not have other title types that would indicate a record other than a program title.
    #     NOTE: The presence of any of these other titles is enough to indicate that the record is *not* a program record.
    #     NOTE: A program record may have title types other than "Program", namely it may also have titles of type "Series" and "Episode",
    #       but for our consideration, it is still a Program record.
    def is_program? 
      !doc.program_title.empty? && non_program_titles.empty? && !self.is_image?
    end

    def non_program_titles
      # get all of the title types that would indicate a record *other* than a Program record
      @non_program_titles ||= doc.titles_by_type.keys.select do |title_type|
        !!(title_type =~ /^Element/) || !!(title_type =~ /^Item/) || !!(title_type =~ /^Segment/) || !!(title_type =~ /^Clip/)  
      end
    end

    # Returns true if PbcoreDescDoc datastream describes a Program record
    # It is a Program if:
    #   - the media type is "moving image"
    def is_video? 
      !media_type.nil? && media_type.downcase ==  "moving image"
    end

    # Returns true if PbcoreDescDoc datastream describes a Program record
    # It is a Program if:
    #   - the media type is "static image"
    #   - OR
    #   - the asset type contains the string with "photograph"
    def is_image? 
      (!media_type.nil? && media_type.downcase == "static image") || (!asset_type.nil? && asset_type.downcase.include?("photograph"))
    end

    # Returns true if PbcoreDescDoc datastream describes a Program record
    # It is a Program if:
    #   - the media type is "audio"
    def is_audio? 
      !media_type.nil? && media_type.downcase == "audio"
    end

    def asset_type 
      @asset_type ||= doc.asset_type.first
    end

    def media_type
      @media_type ||= doc.instantiations(0).media_type.first
    end

    # Returns true if PbcoreDescDoc datastream describes a Program record
    # It is a Program if:
    #   - the asset type contains the string "transcript"
    def is_transcript? 
      !asset_type.nil? && asset_type.downcase.include?('transcript')
    end
  end

  class Ingester
    attr_accessor :xml, :pids 

    def initialize(xml)
      @xml = xml
      @pids = []
    end

    def find_by_pbcore_ids pbcore_ids
      pbcore_ids = Array.wrap(pbcore_ids)
      ActiveFedora::Base.find("all_ids_tesim" => pbcore_ids)
    end

    def ng_xml
      @namespaced_xml ||= Openvault::XML(xml)
      @ng_xml ||= @namespaced_xml.remove_namespaces!
    end

    def ng_pbcore_desc_docs 
      @ng_pbcore_desc_docs ||= ng_xml.xpath('//pbcoreDescriptionDocument')
    end

    def with_desc_docs &block
      ng_pbcore_desc_docs.each do |ng_pbcore_desc_doc|
        wrapper = DescriptionDocumentWrapper.new
        wrapper.doc = PbcoreDescDoc.new.tap do |doc|
                        doc.ng_xml = ng_pbcore_desc_doc
                      end
        
        yield wrapper
      end
    end

    def ingest!
      with_desc_docs do |doc|
        doc.model.save! 
        self.pids << doc.model.pid
      end

      relate_pids!
    end

    def ingest 
      with_desc_docs do |doc|
        doc.model.save && (self.pids << doc.model.pid)
      end

      relate_pids
    end

    def relate_pids!
      pids.each do |pid|
        OpenvaultAsset.find(pid, cast: true).try(:create_relations_from_pbcore!)
      end
    end

    def relate_pids
      pids.each do |pid|
        begin
          OpenvaultAsset.find(pid, cast: true).try(:create_relations_from_pbcore!)
        rescue Exception => e
          Rails.logger.error("** Error: #{e.message}")
        end
      end
    end
  end
end
