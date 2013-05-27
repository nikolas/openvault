require 'spec_helper'

describe Datastream::UOIS do

  # TODO: Consider replacing XML fixtures with an XML factory, if you can find one.
  context "when given valid UOIS" do

    # Give the datastream valid UOIS xml
    before(:all) {
      @uois = Datastream::UOIS.new
      @uois.ng_xml = Nokogiri::XML(File.read("#{fixture_path}/ingest/uois.xml"))
    }

    it "has metadata for security policy" do
      @uois.security_policy_uois.sec_policy_id.should == ["12"]
    end

    it "has metadata for rights" do
      @uois.wgbh_rights.rights_note.should == ["Media not to be released to Open Vault"]
      @uois.wgbh_rights.rights_credit.should == ["WGBH Educational Foundation"]
      @uois.wgbh_rights.rights_type.should == ["Web"]
      @uois.wgbh_rights.rights_holder.should == ["WGBH Educational Foundation"]
    end

    it "has metadata for subject" do
      @uois.wgbh_subject.subject.should == ["Preteens", "Zoom (Television program : WGBH (Television station : Boston, Mass.))"]
      @uois.wgbh_subject.subject_type.should == ["Subject Heading", "Corporate"]
    end

    it "has metadata for item type" do
      @uois.wgbh_type.item_type.should == ["Viewing copy"]
    end
    
    it "has metadata for description" do
      @uois.wgbh_description.description_type.should == ["Description"]
      @uois.wgbh_description.description.should == ["Re-live what it was like to be a ZOOMer in the 1970's, with this retrospective collection of games and music numbers from the Emmy award-winning Children's series."]
      @uois.wgbh_description.description_coverage_out.should == ["01:39:13;07"]
      @uois.wgbh_description.description_coverage.should == ["00:39:13;08"]
      @uois.wgbh_description.description_coverage_in.should == ["01:00:00;00"]
    end
    
    it "has metadata for format" do
      @uois.wgbh_format.dimensions_height.should == ["480"]
      @uois.wgbh_format.aspect_ratio.should == ["4:3"]
      @uois.wgbh_format.broadcast_format.should == ["NTSC"]
      @uois.wgbh_format.duration.should == ["00:39:38;10"]
      @uois.wgbh_format.color.should == ["Color"]
      @uois.wgbh_format.dimensions_width.should == ["720"]
      @uois.wgbh_format.item_format.should == ["Betacam"]
      @uois.wgbh_format.mime_type.should == ["video/quicktime"]
    end
    
    it "has metadata for title" do
      @uois.wgbh_title.title_type.should == ["Program", "Collection", "Series"]
      @uois.wgbh_title.title.should == ["Best of the 70's", "From the Vault", "ZOOM, Series II"]
    end
    
    it "has metadata for annotations" do
      @uois.wgbh_annotation.annotation.should == ["(Audio Track 1) samples per second : 48000 ", "(Audio Track 2) start time : 0.000 seconds ", "(Audio Track 2) duration : 2378.312 seconds "]
      @uois.wgbh_annotation.annotation_type.should == ["Audio Quality2", "Audio Quality2", "Audio Quality2"]
    end
    
    it "has metadata for source" do
      @uois.wgbh_source.source_type.should == ["Tracking Number"]
      @uois.wgbh_source.source.should == ["321909"]
    end
    
    it "has metadata for language" do
      @uois.wgbh_language.language_usage == ["Dialogue"]
      @uois.wgbh_language.language.should == ["eng"]
    end
    
    it "has metadata for publisher" do
      @uois.wgbh_publisher.publisher.should == ["WGBH Educational Foundation"]
      @uois.wgbh_publisher.publisher_type.should == ["Publisher"]
    end
    
    it "has metadata for holdings" do
      @uois.wgbh_holdings.holdings_department.should == ["Archives"]
    end
  end

end