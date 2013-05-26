class Datastream::Uois < ActiveFedora::OmDatastream

  set_terminology do |t|

    t.root(:path => "UOIS") {
      t.version(:path => {:attribute => "VERSION"})
      t.import_dt(:path => {:attribute => "IMPORT_DT"})
      t.uoi_id(:path => {:attribute => "UOI_ID"})
      t.name(:path => {:attribute => "NAME"})
      t.import_user_id(:path => {:attribute => "IMPORT_USER_ID"})
      t.import_id(:path => {:attribute => "IMPORT_ID"})
    }

    t.security_policy_uois(:path => "SECURITY_POLICY_UOIS") {
      t.sec_policy_id(:path => {:attribute => "SEC_POLICY_ID"})
    }

    t.wgbh_rights(:path => "WGBH_RIGHTS") {
      t.rights_note(:path => {:attribute => "RIGHTS_NOTE"})
      t.rights_type(:path => {:attribute => "RIGHTS_TYPE"})
      t.rights_credit(:path => {:attribute => "RIGHTS_CREDIT"})
      t.rights_holder(:path => {:attribute => "RIGHTS_HOLDER"})
    }

    t.wgbh_subject(:path => "WGBH_SUBJECT") {
      t.subject(:path => {:attribute => "SUBJECT"})
      t.subject_type(:path => {:attribute => "SUBJECT_TYPE"})
    }

    t.wgbh_type(:path => 'WGBH_TYPE') {
      t.item_type(:path => {:attribute => 'ITEM_TYPE'})
    }

    t.wgbh_description(:path => "WGBH_DESCRIPTION") {
      t.description(:path => {:attribute => "DESCRIPTION"})
      t.description_type(:path => {:attribute => "DESCRIPTION_TYPE"})
      t.description_coverage(:path => {:attribute => "DESCRIPTION_COVERAGE"})
      t.description_coverage_in(:path => {:attribute => "DESCRIPTION_COVERAGE_IN"})
      t.description_coverage_out(:path => {:attribute => "DESCRIPTION_COVERAGE_OUT"})
    }

    t.wgbh_format(:path => "WGBH_FORMAT") {
      t.item_format(:path => {:attribute => "ITEM_FORMAT"})
      t.mime_type(:path => {:attribute => "MIME_TYPE"})
      t.broadcast_format(:path => {:attribute => "BROADCAST_FORMAT"})
      t.duration(:path => {:attribute => "DURATION"})
      t.aspect_ratio(:path => {:attribute => "ASPECT_RATIO"})
      t.dimensions_width(:path => {:attribute => "DIMENSIONS_WIDTH"})
      t.dimensions_height(:path => {:attribute => "DIMENSIONS_HEIGHT"})
      t.color(:path => {:attribute => "COLOR"})
    }

    t.wgbh_title(:path => "WGBH_TITLE") {
      t.title_type(:path => {:attribute => "TITLE_TYPE"})
      t.title(:path => {:attribute => "TITLE"})
    }

    t.wgbh_annotation(:path => "WGBH_ANNOTATION") {
      t.annotation(:path => {:attribute => "ANNOTATION"})
      t.annotation_type(:path => {:attribute => "ANNOTATION_TYPE"})
    }

    t.wgbh_source(:path => "WGBH_SOURCE") {
      t.source_type(:path => {:attribute => "SOURCE_TYPE"})
      t.source(:path => {:attribute => "SOURCE"})
    }

    t.wgbh_language(:path => "WGBH_LANGUAGE") {
      t.language_usage(:path => {:attribute => "LANGUAGE_USAGE"})
      t.language(:path => {:attribute => "LANGUAGE"})
    }

    t.wgbh_publisher(:path => "WGBH_PUBLISHER") {
      t.publisher_type(:path => {:attribute => "PUBLISHER_TYPE"})
      t.publisher(:path => {:attribute => "PUBLISHER"})
    }

    t.wgbh_holdings(:path => "WGBH_HOLDINGS") {
      t.holdings_department(:path => {:attribute => "HOLDINGS_DEPARTMENT"})
    }
  end

  class << self
    def xml_template
      Nokogiri::XML.parse("<UOIS/>")
    end  
  end
  
end