require 'spec_helper'

describe Datastream::UOIS do

  # TODO: Consider replacing XML fixtures with an XML factory, if you can find one.
  context "when given valid UOIS" do

    # Give the datastream valid UOIS xml
    before(:all) {
      @uois = Datastream::UOIS.new
      @uois.set_xml File.read("#{fixture_path}/artesia_ingest/zoom/uois_program.xml")
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
      @uois.wgbh_subject.subject.should == ["Preteens", "Variety shows (Television programs)", "Zoom (Television program : WGBH (Television station : Boston, Mass.))", "Children's television programs--United States", "Children", "Play", "Children's television programs", "Games", "Amusements"]
      @uois.wgbh_subject.subject_type.should == ["Subject Heading", "Subject Heading", "Corporate", "Subject Heading", "Subject Heading", "Subject Heading", "Subject Heading", "Subject Heading", "Subject Heading"]
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
      @uois.wgbh_title.title_type.should == ["Program", "Series"]
      @uois.wgbh_title.title.should == ["Best of the 70's", "ZOOM, Series II"]
    end
    
    it "has metadata for annotations" do
      @uois.wgbh_annotation.annotation.should == ["(Video Track 1) width/height/depth : 720 / 480 / 24 ", "(Video Track 1) compression format : dv5n Apple DVCPRO50 - NTSC ", "(Audio Track 3) compression format : in24 24-bit Integer ", "(Audio Track 3) bits/channels : 16 / 1 ", "(Audio Track 1) duration : 2378.312 seconds ", "(Audio Track 1) compression format : in24 24-bit Integer ", "/Volumes/bigDisks/Final Cut Pro Documents/Capture Scratch/Zoom/barcode321909.mov", "(Audio Track 6) start time : 0.000 seconds ", "(Audio Track 6) samples per second : 48000 ", "(Audio Track 7) start time : 0.000 seconds ", "(Audio Track 7) duration : 2378.312 seconds ", "(Audio Track 7) compression format : in24 24-bit Integer ", "(Audio Track 7) bits/channels : 16 / 1 ", "(Audio Track 7) samples per second : 48000 ", "(Audio Track 8) start time : 0.000 seconds ", "(Audio Track 8) duration : 2378.312 seconds ", "(Audio Track 8) compression format : in24 24-bit Integer ", "(Audio Track 8) bits/channels : 16 / 1 ", "(Audio Track 6) bits/channels : 16 / 1 ", "(Audio Track 1) start time : 0.000 seconds ", "(Audio Track 1) samples per second : 48000 ", "(Audio Track 2) start time : 0.000 seconds ", "(Audio Track 2) duration : 2378.312 seconds ", "(Audio Track 2) compression format : in24 24-bit Integer ", "(Audio Track 2) bits/channels : 16 / 1 ", "(Audio Track 3) start time : 0.000 seconds ", "(Audio Track 3) duration : 2378.312 seconds ", "(Audio Track 4) start time : 0.000 seconds ", "(Audio Track 4) duration : 2378.312 seconds ", "(Audio Track 4) bits/channels : 16 / 1 ", "(Audio Track 4) samples per second : 48000 ", "(Audio Track 5) start time : 0.000 seconds ", "(Audio Track 1) bits/channels : 16 / 1 ", "(Audio Track 5) duration : 2378.312 seconds ", "(Audio Track 2) samples per second : 48000 ", "(Audio Track 5) compression format : in24 24-bit Integer ", "(Audio Track 5) bits/channels : 16 / 1 ", "(Audio Track 5) samples per second : 48000 ", "(Audio Track 4) compression format : in24 24-bit Integer ", "(Audio Track 3) samples per second : 48000 ", "(Audio Track 6) duration : 2378.312 seconds ", "(Audio Track 6) compression format : in24 24-bit Integer ", "(Video Track 1) start time : 0.000 seconds ", "(Video Track 1) duration : 2378.312 seconds ", "(Video Track 1) frames per second : 29.97 ", "(Audio Track 8) samples per second : 48000 "]
      @uois.wgbh_annotation.annotation_type.should == ["Movie Quality", "Movie Quality", "Audio Quality2", "Audio Quality2", "Audio Quality2", "Audio Quality2", "Source", "Audio Quality2", "Audio Quality2", "Audio Quality2", "Audio Quality2", "Audio Quality2", "Audio Quality2", "Audio Quality2", "Audio Quality2", "Audio Quality2", "Audio Quality2", "Audio Quality2", "Audio Quality2", "Audio Quality2", "Audio Quality2", "Audio Quality2", "Audio Quality2", "Audio Quality2", "Audio Quality2", "Audio Quality2", "Audio Quality2", "Audio Quality2", "Audio Quality2", "Audio Quality2", "Audio Quality2", "Audio Quality2", "Audio Quality2", "Audio Quality2", "Audio Quality2", "Audio Quality2", "Audio Quality2", "Audio Quality2", "Audio Quality2", "Audio Quality2", "Audio Quality2", "Audio Quality2", "Movie Quality", "Movie Quality", "Movie Quality", "Audio Quality2"]
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