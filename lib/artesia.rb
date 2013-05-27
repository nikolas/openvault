module Artesia

  module Datastreams

    ##
    # Provide UOIS goodies to classes that extend +ActiveFedora::OmDatastream+.
    #
    # = Example
    #   
    #   class MyDatastream < ActiveFedora::OmDatastream
    #     include Artesia::Datastreams::UOIS
    #
    module UOIS      
      extend ActiveSupport::Concern

      module ClassMethods

        ##
        # Adds terminology for attributes and children of a UOIS node.
        # * *Args*
        #   - +terminology+ +OM::XML::Terminology+
        def add_uois_terminology(terminology)
          terminology.version(:path => {:attribute => "VERSION"})
          terminology.import_dt(:path => {:attribute => "IMPORT_DT"})
          terminology.uoi_id(:path => {:attribute => "UOI_ID"})
          terminology.name(:path => {:attribute => "NAME"})
          terminology.import_user_id(:path => {:attribute => "IMPORT_USER_ID"})
          terminology.import_id(:path => {:attribute => "IMPORT_ID"})

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
      end
    end
  end

  class Ingester

    class << self
      def ingest!(teams_asset_file_xml)
        artesia_ingest = ArtesiaIngest.create!
        artesia_ingest.teams_asset_file.ng_xml = Nokogiri::XML(teams_asset_file_xml)

        artesia_ingest.teams_asset_file.find_by_terms(:assets, :asset, :metadata, :uois).each do |ng_uois|

          ov_asset = OpenvaultAsset.new
          # ng_uois is a Nokogiri::XML::Element, but we want a Nokogiri::XML::Document, so re-parse it.
          ov_asset.uois.ng_xml = Nokogiri::XML(ng_uois.to_xml)

          # Add the OpenvaultAsset to the ArtesiaIngest.
          # Note that because the ArtesiaIngest instance is already saved,
          # the new OpenvaultAsset will be saved automatically when it is added.
          artesia_ingest.openvault_assets << ov_asset
        end
      end
    end
  end
end