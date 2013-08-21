require 'openvault/datastream'

module Artesia

  module Datastream

    ##
    # Class Artesia::Datastream::UOIS
    # Represents UOIS XML metadata for a single asset.
    #
    class UOIS < ActiveFedora::OmDatastream

      include Openvault::Datastream

      ##
      # Adds terminology for attributes and children of a UOIS node.
      # Abstracted into a class method for re-use by Artesia::Datastream::TeamsAssetFile
      # Params:
      #   * terminology -- instance of OM::XML::Terminology
      def self.add_uois_terminology(terminology)

        terminology.uoi_id(:path => {:attribute => "UOI_ID"})
        terminology.filename(:path => {:attribute => "NAME"})
        terminology.master_obj_mime_type(:path => {:attribute => "MASTER_OBJ_MIME_TYPE"})

        terminology.security_policy(:path => "SECURITY_POLICY_UOIS/@SEC_POLICY_ID")

        # All creators, with name and role
        terminology.creators(:path => "WGBH_CREATOR") {
          terminology.name(:path => {:attribute => "CREATOR_NAME"})
          terminology.role(:path => {:attribute => "CREATOR_ROLE"})
        }

        # Specific creator info
        terminology.artists(:path => 'WGBH_CREATOR[@CREATOR_ROLE="Artist"]/@CREATOR_NAME')
        terminology.directors(:path => 'WGBH_CREATOR[@CREATOR_ROLE="Director2" or @CREATOR_ROLE="Director3"]/@CREATOR_NAME')
        terminology.producers(:path => 'WGBH_CREATOR[@CREATOR_ROLE="Producer"]/@CREATOR_NAME')
        terminology.exec_producers(:path => 'WGBH_CREATOR[@CREATOR_ROLE="Executive Producer2" or @CREATOR_ROLE="Executive Producer5000"]/@CREATOR_NAME')
        terminology.senior_producers(:path => 'WGBH_CREATOR[@CREATOR_ROLE="Senior Producer5000"]/@CREATOR_NAME')
        terminology.all_producers(:path => 'WGBH_CREATOR[@CREATOR_ROLE="Executive Producer2" or @CREATOR_ROLE="Executive Producer5000" or @CREATOR_ROLE="Senior Producer5000" or @CREATOR_ROLE="Producer"]/@CREATOR_NAME')
        terminology.photographer(:path => 'WGBH_CREATOR[@CREATOR_ROLE="Photographer"]/@CREATOR_NAME')
        terminology.illustrator(:path => 'WGBH_CREATOR[@CREATOR_ROLE="Illustrator"]/@CREATOR_NAME')
        
        terminology.rights(:path => "WGBH_RIGHTS") {
          terminology.note(:path => {:attribute => "RIGHTS_NOTE"})
          terminology.type(:path => {:attribute => "RIGHTS_TYPE"})
          terminology.credit(:path => {:attribute => "RIGHTS_CREDIT"})
          terminology.holder(:path => {:attribute => "RIGHTS_HOLDER"})
        }

        # All subjects
        terminology.subjects(:path => "WGBH_SUBJECT") {
          terminology.type(:path => {:attribute => "SUBJECT_TYPE"})
          terminology.value(:path => {:attribute => "SUBJECT"})
        }

        # ["Corporate", "Geographical", "Keyword", "Personal", "Personalities", "Subject Heading", "Topical"]

        # NOTE: #types(from WGBH_TYPE/@ITEM_TYPE in UOIS xml) is not related to #item_titles (from WGBH_TITLE[@TYPE="ITEM"]/@TITLE in UOIS xml).
        # All digital assets should have a #types But #item_titles is for an asset that is of type 'Item', which is a stupidly generic designation
        # that basically means 'a part of something else'.
        terminology.types(:path => 'WGBH_TYPE/@ITEM_TYPE')
        terminology.media_types(:path => 'WGBH_TYPE/@MEDIA_TYPE')


        terminology.description(:path => "WGBH_DESCRIPTION") {
          terminology.type(:path => {:attribute => "DESCRIPTION_TYPE"})
          terminology.coverage_in(:path => {:attribute => "DESCRIPTION_COVERAGE_IN"})
          terminology.coverage(:path => {:attribute => "DESCRIPTION_COVERAGE"})
          terminology.coverage_out(:path => {:attribute => "DESCRIPTION_COVERAGE_OUT"})
          terminology.value(:path => {:attribute => "DESCRIPTION"})
        }

        # All titles with types and values.
        terminology.titles(:path => 'WGBH_TITLE') {
          terminology.type(:path => {:attribute => 'TITLE_TYPE'})
          terminology.value(:path => {:attribute => 'TITLE'})
        }

        # Specific titles
        terminology.series_titles(:path => 'WGBH_TITLE[@TITLE_TYPE="Series"]/@TITLE')
        terminology.subseries_titles(:path => 'WGBH_TITLE[@TITLE_TYPE="Subseries"]/@TITLE')
        terminology.program_titles(:path => 'WGBH_TITLE[@TITLE_TYPE="Program"]/@TITLE')
        terminology.collection_titles(:path => 'WGBH_TITLE[@TITLE_TYPE="Collection"]/@TITLE')
        terminology.episode_titles(:path => 'WGBH_TITLE[@TITLE_TYPE="Episode"]/@TITLE')
        terminology.element_titles(:path => 'WGBH_TITLE[@TITLE_TYPE="Element2" or @TITLE_TYPE="Element3" or @TITLE_TYPE="Element4"]/@TITLE')
        terminology.clip_titles(:path => 'WGBH_TITLE[@TITLE_TYPE="Clip"]/@TITLE')
        # NOTE: #item_titles (from WGBH_TITLE[@TYPE="ITEM"]/@TITLE in UOIS xml) is not related to #types(from WGBH_TYPE/@ITEM_TYPE in UOIS xml).
        # All digital assets should have a #types But #item_titles is for an asset that is of type 'Item', which is a stupidly generic designation
        # that basically means 'a part of something else'.
        terminology.item_titles(:path => 'WGBH_TITLE[@TITLE_TYPE="Item2" or @TITLE_TYPE="Item3" or @TITLE_TYPE="Item4"]/@TITLE')

        # Publisher info
        terminology.publishers(:path => 'WGBH_PUBLISHER[@PUBLISHER_TYPE="Publisher"]/@PUBLISHER')
        terminology.copyright_holders(:path => 'WGBH_PUBLISHER[@PUBLISHER_TYPE="Copyright Holder"]/@PUBLISHER')
        terminology.distributors(:path => 'WGBH_PUBLISHER[@PUBLISHER_TYPE="Distributor"]/@PUBLISHER')

      end

      set_terminology do |t|
        t.root(:path => "UOIS")
        self.add_uois_terminology t
      end


      # Returns a default xml doc for the datastream.
      # Required (or at least preferred) by ActiveFedora::OmDatastream
      def self.xml_template
        Nokogiri::XML.parse("<UOIS/>")
      end

      # Returns true if XML describes a series record.
      # It is a series record iff:
      #   - The one and only title is the series title.
      #   - Does NOT exclusively describe an image (because some images records may be for a whole series, e.g. a poster, and include the series title)
      def is_series?
        !self.series_titles.empty? && self.titles.count == 1 && !self.is_image?
      end

      # Returns true if XML descrbes a program record.
      # It is a program record if:
      #   - It has "Program" exists within titles.type (there may be more than just "Program")
      #   - Does NOT exclusively describing any of the following:
      #     - series record
      #     - collection record
      #     - image record (although a program record may have an image within it, it is not an image record in and of itself)
      #     - transcript record
      # NOTE: Sometimes a video or audio record will also serve as the program record.
      def is_program?
        !self.program_titles.empty? && !(self.is_series? || self.is_collection? || self.is_transcript? || self.is_image? || self.is_element? || self.is_clip?)
      end

      # Returns true if XML describes a collection record.
      # It is a collection record iff:
      #  - titles.type contains "Collection"
      def is_collection?
        !self.collection_titles.empty?
      end

      # Returns true if XML describes a video.
      # It is a video record iff:
      #   - The media_typescontains "Moving Image" and nothing else.
      def is_video?
        (self.media_types== ["Moving Image"])
      end

      def is_element?
        !self.element_titles.empty?
      end

      def is_clip?
        !self.clip_titles.empty?
      end

      # Returns tue if XML describes a transcript
      # It is a transcript record iff:
      #   - types contains at least one value that begins with "Transcript"
      def is_transcript?
        (self.types.grep(/^Transcript/).count > 0)
      end

      # Returns true if XML describes an image.
      # It is an image record iff:
      #   - types contains "Static Image" and nothing else.
      #   - OR the master_obj_mime_type (from root node) contains a value that begins with "image".
      def is_image?
        (self.types == ['Static Image']) || (self.master_obj_mime_type.grep(/^image/).count > 0)
      end

      # Returns true if XML describes audio.
      # It is an audio record iff:
      #   - media_typescontains "Audio" and nothing else.
      def is_audio?
        (self.media_types== ["Audio"])
      end

      # Converts to a HydraPbcore::Datastream::Document
      def to_pbcore
        pbcore = HydraPbcore::Datastream::Document.new
        
        # Titles
        pbcore.episode
      end
    end
  end
end