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
        terminology.version(:path => {:attribute => "VERSION"})
        terminology.import_dt(:path => {:attribute => "IMPORT_DT"})
        terminology.uoi_id(:path => {:attribute => "UOI_ID"})
        terminology.name(:path => {:attribute => "NAME"})
        terminology.import_user_id(:path => {:attribute => "IMPORT_USER_ID"})
        terminology.import_id(:path => {:attribute => "IMPORT_ID"})
        terminology.master_obj_mime_type(:path => {:attribute => "MASTER_OBJ_MIME_TYPE"})

        terminology.security_policy_uois(:path => "SECURITY_POLICY_UOIS") {
          terminology.sec_policy_id(:path => {:attribute => "SEC_POLICY_ID"})
        }

        terminology.wgbh_rights(:path => "WGBH_RIGHTS") {
          terminology.rights_note(:path => {:attribute => "RIGHTS_NOTE"})
          terminology.rights_type(:path => {:attribute => "RIGHTS_TYPE"})
          terminology.rights_credit(:path => {:attribute => "RIGHTS_CREDIT"})
          terminology.rights_holder(:path => {:attribute => "RIGHTS_HOLDER"})
        }

        terminology.wgbh_subject(:path => "WGBH_SUBJECT") {
          terminology.subject(:path => {:attribute => "SUBJECT"})
          terminology.subject_type(:path => {:attribute => "SUBJECT_TYPE"})
        }

        terminology.wgbh_type(:path => 'WGBH_TYPE') {
          terminology.media_type(:path => {:attribute => 'MEDIA_TYPE'})
          terminology.item_type(:path => {:attribute => 'ITEM_TYPE'})
        }

        terminology.wgbh_description(:path => "WGBH_DESCRIPTION") {
          terminology.description_type(:path => {:attribute => "DESCRIPTION_TYPE"})
          terminology.description_coverage_in(:path => {:attribute => "DESCRIPTION_COVERAGE_IN"})
          terminology.description_coverage(:path => {:attribute => "DESCRIPTION_COVERAGE"})
          terminology.description_coverage_out(:path => {:attribute => "DESCRIPTION_COVERAGE_OUT"})
          terminology.description(:path => {:attribute => "DESCRIPTION"})
        }

        terminology.wgbh_format(:path => "WGBH_FORMAT") {
          terminology.dimensions_height(:path => {:attribute => "DIMENSIONS_HEIGHT"})
          terminology.aspect_ratio(:path => {:attribute => "ASPECT_RATIO"})
          terminology.broadcast_format(:path => {:attribute => "BROADCAST_FORMAT"})
          terminology.duration(:path => {:attribute => "DURATION"})
          terminology.color(:path => {:attribute => "COLOR"})
          terminology.dimensions_width(:path => {:attribute => "DIMENSIONS_WIDTH"})
          terminology.item_format(:path => {:attribute => "ITEM_FORMAT"})
          terminology.mime_type(:path => {:attribute => "MIME_TYPE"})
        }

        terminology.wgbh_title(:path => "WGBH_TITLE") {
          terminology.title_type(:path => {:attribute => "TITLE_TYPE"})
          terminology.title(:path => {:attribute => "TITLE"})
        }

        terminology.wgbh_annotation(:path => "WGBH_ANNOTATION") {
          terminology.annotation(:path => {:attribute => "ANNOTATION"})
          terminology.annotation_type(:path => {:attribute => "ANNOTATION_TYPE"})
        }

        terminology.wgbh_source(:path => "WGBH_SOURCE") {
          terminology.source_type(:path => {:attribute => "SOURCE_TYPE"})
          terminology.source(:path => {:attribute => "SOURCE"})
        }

        terminology.wgbh_language(:path => "WGBH_LANGUAGE") {
          terminology.language_usage(:path => {:attribute => "LANGUAGE_USAGE"})
          terminology.language(:path => {:attribute => "LANGUAGE"})
        }

        terminology.wgbh_publisher(:path => "WGBH_PUBLISHER") {
          terminology.publisher_type(:path => {:attribute => "PUBLISHER_TYPE"})
          terminology.publisher(:path => {:attribute => "PUBLISHER"})
        }

        terminology.wgbh_holdings(:path => "WGBH_HOLDINGS") {
          terminology.holdings_department(:path => {:attribute => "HOLDINGS_DEPARTMENT"})
        }
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

      # Converts UOIS xml to PBCore xml
      def to_pbcore_xml
        Openvault::Datastream::Converter.uois_to_pbcore(self.to_xml)
      end
    end
  end
end