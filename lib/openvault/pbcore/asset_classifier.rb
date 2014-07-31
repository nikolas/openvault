module Openvault::Pbcore
  class AssetClassifier
    attr_accessor :doc

    # TODO: Rename this method! It's too easy to confuse
    # with Openvault::Pbcore#asset_type, which returns
    # the value inside of <pbcoreAssetType></pbcoreAssetType>,
    # which is totally different than what this class method does.
    def self.asset_types
      %w(series program transcript video audio image)
    end

    def initialize(doc=nil)
      @doc = doc
    end

    # Raises exception if PbcoreDescDoc datastream matches multiple models.
    def one_model?
      models = [] 
      Openvault::Pbcore::AssetClassifier.asset_types.each do |model|
        models << model if Openvault::Pbcore::AssetClassifier.new(doc).send("is_#{model}?")
      end
      raise "Document should only be one model: #{models}" if models.length != 1
      return true
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
      !doc.program_title.empty? &&
      non_program_titles.empty? &&
      non_program_asset_types.reduce { |r, type| r && !send("is_#{type}?".to_sym) }
    end

    # TODO: Rename this method!
    # The method #asset_type returns the value inside of <pbcoreAssetType>...</pbcoreAssetType>
    # for a given <pbcoreDescriptionDocument>.
    # The class method `.asset_types` was added later and probably was not aware of the potential
    # for confusion.
    def non_program_asset_types
      AssetClassifier.asset_types - ['program']
    end

    # Returns true if PbcoreDescDoc datastream describes a Video record
    # It is a Video if:
    #   - the media type is "moving image"
    def is_video?
      (!media_type.nil? && media_type.downcase ==  "moving image") || (!asset_type.nil? && (asset_type.downcase == 'preservation master'))
    end

    # Returns true if PbcoreDescDoc datastream describes an Image record
    # It is an Image if:
    #   - the media type is "static image"
    #   - OR
    #   - the asset type contains the string with "photograph"
    def is_image?
      (!media_type.nil? && media_type.downcase == "static image") || (!asset_type.nil? && asset_type.downcase.include?("photograph"))
    end

    # Returns true if PbcoreDescDoc datastream describes an Audio record
    # It is a Audio if:
    #   - the media type is "audio"
    def is_audio?
      !media_type.nil? && media_type.downcase == "audio"
    end

    # Returns true if PbcoreDescDoc datastream describes a Transcript record
    # It is a Transcript if:
    #   - the asset type contains the string "transcript"
    def is_transcript?
      (!asset_type.nil? && asset_type.downcase.include?('transcript'))
    end

    # TODO: Rename the class methods AssetClassifier.asset_types
    # and AssetClassifier#non_program_asset_types as they are too easy
    # to confuse with this method, which specifically returns the value
    # for a given <pbcoreAssetType>...</pbcoreAssetType>.
    def asset_type
      @asset_type ||= doc.asset_type.first
    end

    def media_type
      @media_type ||= doc.instantiations(0).media_type.first
    end

    # There are some title types that can be included on a program record,
    # and other title types that indicate the record is something other than a program.
    # This method returns the latter.
    def non_program_titles
      @non_program_titles ||= doc.titles_by_type.keys.select do |title_type|
        !!(title_type =~ /^Element/) || !!(title_type =~ /^Item/) || !!(title_type =~ /^Segment/) || !!(title_type =~ /^Clip/)
      end
    end
  end
end
