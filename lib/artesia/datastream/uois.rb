require 'openvault'
require 'hydra-pbcore'

module Artesia

  module Datastream

    ##
    # Class Artesia::Datastream::UOIS
    # Represents UOIS XML metadata for a single asset.
    #
    class UOIS < ActiveFedora::OmDatastream

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

        # Coverage specifics
        terminology.dates_portrayed(:path => "WGBH_COVERAGE/@DATE_PORTRAYED")
        terminology.event_locations(:path => "WGBH_COVERAGE/@EVENT_LOCATION")

        # All subjects
        terminology.subjects(:path => "WGBH_SUBJECT") {
          terminology.type(:path => {:attribute => "SUBJECT_TYPE"})
          terminology.value(:path => {:attribute => "SUBJECT"})
        }

        # Specific subjects
        terminology.subjects_corporate(:path => 'WGBH_SUBJECT[@SUBJECT_TYPE="Corporate"]/@SUBJECT')
        terminology.subjects_geographical(:path => 'WGBH_SUBJECT[@SUBJECT_TYPE="Geographical"]/@SUBJECT')
        terminology.subjects_keywords(:path => 'WGBH_SUBJECT[@SUBJECT_TYPE="Keyword"]/@SUBJECT')
        terminology.subjects_personal(:path => 'WGBH_SUBJECT[@SUBJECT_TYPE="Personal"]/@SUBJECT')
        terminology.subjects_personalities(:path => 'WGBH_SUBJECT[@SUBJECT_TYPE="Personalities"]/@SUBJECT')
        terminology.subjects_headings(:path => 'WGBH_SUBJECT[@SUBJECT_TYPE="Subject Heading"]/@SUBJECT')
        terminology.subjects_topical(:path => 'WGBH_SUBJECT[@SUBJECT_TYPE="Topical"]/@SUBJECT')

        # NOTE: #types(from WGBH_TYPE/@ITEM_TYPE in UOIS xml) is not related to #item_titles (from WGBH_TITLE[@TYPE="ITEM"]/@TITLE in UOIS xml).
        # All digital assets should have a #types But #item_titles is for an asset that is of type 'Item', which is a stupidly generic designation
        # that basically means 'a part of something else'.
        terminology.types(:path => 'WGBH_TYPE/@ITEM_TYPE')
        terminology.media_types(:path => 'WGBH_TYPE/@MEDIA_TYPE')

        # All descriptions
        # We're not worrying about different types of descriptions right now. They are all basically summaries.
        terminology.descriptions(:path => "WGBH_DESCRIPTION/@DESCRIPTION")

        terminology.coverage(:path => 'WGBH_DESCRIPTION/@DESCRIPTION_COVERAGE')
        terminology.coverage_in(:path => 'WGBH_DESCRIPTION/@DESCRIPTION_COVERAGE_IN')
        terminology.coverage_out(:path => 'WGBH_DESCRIPTION/@DESCRIPTION_COVERAGE_OUT')

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
        terminology.segment_titles(:path => 'WGBH_TITLE[@TITLE_TYPE="Segment"]/@TITLE')
        terminology.image_titles(:path => 'WGBH_TITLE[@TITLE_TYPE="Image"]/@TITLE')
        # NOTE: #item_titles (from WGBH_TITLE[@TYPE="ITEM"]/@TITLE in UOIS xml) is not related to #types(from WGBH_TYPE/@ITEM_TYPE in UOIS xml).
        # All digital assets should have a #types But #item_titles is for an asset that is of type 'Item', which is a stupidly generic designation
        # that basically means 'a part of something else'.
        terminology.item_titles(:path => 'WGBH_TITLE[@TITLE_TYPE="Item2" or @TITLE_TYPE="Item3" or @TITLE_TYPE="Item4"]/@TITLE')

        # Publisher info
        terminology.publishers(:path => 'WGBH_PUBLISHER') {
          terminology.type(:path => {:attribute => 'PUBLISHER_TYPE'})
          terminology.name(:path => {:attribute => 'PUBLISHER'})
        }

        # Publisher info
        terminology.contributors(:path => 'WGBH_CONTRIBUTOR') {
          terminology.name(:path => {:attribute => 'CONTRIBUTOR_NAME'})
          terminology.role(:path => {:attribute => 'CONTRIBUTOR_ROLE'})
        }

      end

      set_terminology do |t|
        t.root(:path => "UOIS")
        self.add_uois_terminology t
      end

      def to_pbcore
        pbcore = HydraPbcore::Datastream::Document.new

        pbcore.series += self.series_titles
        pbcore.collection += self.collection_titles
        pbcore.program += self.program_titles
        pbcore.episode += self.episode_titles
        pbcore.clip += self.clip_titles
        pbcore.segment += self.segment_titles
        pbcore.asset_date += self.dates_portrayed
        pbcore.element += self.element_titles
        pbcore.item += self.item_titles

        pbcore.description += self.descriptions


        # Set the main title based on what the UOIS xml is representing
        if self.is_series?
          pbcore.title += pbcore.series
          pbcore.description.type = "Series"
        elsif self.is_program?
          pbcore.title += pbcore.program
          pbcore.description.type = "Program"
        elsif self.is_collection?
          pbcore.title += pbcore.collection
          pbcore.description.type = "Collection"
        elsif self.is_clip?
          pbcore.title += pbcore.clip
          pbcore.description.type = "Clip"
        elsif self.is_element?
          pbcore.title += pbcore.element
          pbcore.description.type = "Element"
        elsif self.is_item?
          pbcore.title += pbcore.item
          pbcore.description.type = "Item"
        end

        # Append the subjects
        pbcore.subject_name += self.subjects_topical
        pbcore.subject_name += self.subjects_personalities
        pbcore.subject_name += self.subjects_headings

        pbcore.publisher.name = self.publishers.name
        pbcore.publisher.role = self.publishers.type

        pbcore.contributor.name = self.contributors.name
        pbcore.contributor.role = self.contributors.role

        pbcore
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
        !self.program_titles.empty? && !(self.is_series? || self.is_collection? || self.is_transcript? || self.is_image? || self.is_element? || self.is_clip? || self.is_item?)
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

      # I am not a fan of this designation, but an 'Item' in this context is a specific type
      # of asset, similar to an "Element" or a "Clip". Essentially, it is a part of a larger thing.
      # What is the difference between an "Item" and a "Clip", or an "Item" and an "Element"? Dunno.
      def is_item?
        !self.item_titles.empty?
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
    end
  end
end