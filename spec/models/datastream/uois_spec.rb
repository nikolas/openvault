require 'spec_helper'

describe Datastream::UOIS do


  before(:all) do

    fixtures = {

      # Zoom!
      "#{fixture_path}/artesia_ingest/zoom/teams_asset_file.xml" => {
        :series => ["f6d9c1e1c90b14c0f18088e51d139281d7f2ecd1"],
        :program => ["e3616b02f7257101d85c4a0b8e5e7f119ca0556a"],
        :collection => ["ac99f3707a11b13f224eba8494a6e52d1147b305"],
        :video => ["e5551726166cf29bf24f6b32a34edecaa1ee17c2"],
        :image => ["57939d888c14d68ed4e603a17604f693c880e88b"],
      },

      # Rock and Roll
      "#{fixture_path}/artesia_ingest/rock_and_roll/teams_asset_file.xml" => {
        :series => ["34a589fdcb189dec43a5bca693bbc607d544ffa1"],
        :program => ["e3616b02f7257101d85c4a0b8e5e7f119ca0556a"],
        :video => ["44f91989a54c207176af576bd14629000812ba87"],
        :image => [
          "5fc2c6174b99b8724803fd74e93034fe31cd186f",
          "42a5a946dc77f51ba077ee2ac54279b0546e0259"
        ],
        :transcript => ["9de1adedf24bf71802851c0ba923018f8916acce"]
      }
    }

    # Put all the samples together, each inside a new Datastream::UOIS
    @uois = {}
    fixtures.each do |file, uoi_ids|
      ng = Nokogiri::XML(File.read(file))
      uoi_ids.each do |type, uoi_id|
        @uois[type] ||= []
        uois = Datastream::UOIS.new
        uois.set_xml ng.xpath("//UOIS[@UOIS='#{uoi_id}']").to_xml
        @uois[type] << uois
      end
    end
  end

  pending '#is_series?' do
    it 'returns true if <UOIS> xml describes a series' do
      @uois[:series].each do |uois|
        uois.is_series?.should == true
      end
    end
  end

  pending '#is_program?' do
    it 'returns true if <UOIS> xml describes a program' do
      @uois[:program].each do |uois|
        uois.is_program?.should == true
      end
    end
  end

  pending '#is_video?' do
    it 'returns true if <UOIS> xml describes a video' do
      @uois[:video].each do |uois|
        uois.is_video?.should == true
      end
    end
  end

  pending '#is_collection?' do
    it 'returns true if <UOIS> xml describes a collection' do
      @uois[:collection].each do |uois|
        uois.is_collection?.should == true
      end
    end
  end

  pending '#is_image?' do
    it 'returns true if <UOIS> xml describes a image' do
      @uois[:image].each do |uois|
        uois.is_image?.should == true
      end
    end
  end


  pending '#is_transcript?' do
    it 'returns true if <UOIS> xml describes a transcript' do
      @uois[:transcript].each do |uois|
        uois.is_transcript?.should == true
      end
    end
  end


  pending '#is_audio?' do
    it 'returns true if <UOIS> xml describes a audio' do
      @uois[:audio].each do |uois|
        uois.is_audio?.should == true
      end
    end
  end


  # it "has metadata for security policy" do
  #   @uois.security_policy_uois.sec_policy_id.should == ["12"]
  # end

  # it "has metadata for rights" do
  #   @uois.wgbh_rights.rights_note.should == ["Media not to be released to Open Vault"]
  #   @uois.wgbh_rights.rights_credit.should == ["WGBH Educational Foundation"]
  #   @uois.wgbh_rights.rights_type.should == ["Web"]
  #   @uois.wgbh_rights.rights_holder.should == ["WGBH Educational Foundation"]
  # end

  # it "has metadata for subject" do
  #   @uois.wgbh_subject.subject.should == ["Preteens", "Variety shows (Television programs)", "Zoom (Television program : WGBH (Television station : Boston, Mass.))", "Children's television programs--United States", "Children", "Play", "Children's television programs", "Games", "Amusements"]
  #   @uois.wgbh_subject.subject_type.should == ["Subject Heading", "Subject Heading", "Corporate", "Subject Heading", "Subject Heading", "Subject Heading", "Subject Heading", "Subject Heading", "Subject Heading"]
  # end

  # it "has metadata for item type" do
  #   @uois.wgbh_type.item_type.should == ["Viewing copy"]
  # end
  
  # it "has metadata for description" do
  #   @uois.wgbh_description.description_type.should == ["Description"]
  #   @uois.wgbh_description.description.should == ["Re-live what it was like to be a ZOOMer in the 1970's, with this retrospective collection of games and music numbers from the Emmy award-winning Children's series."]
  #   @uois.wgbh_description.description_coverage_out.should == ["01:39:13;07"]
  #   @uois.wgbh_description.description_coverage.should == ["00:39:13;08"]
  #   @uois.wgbh_description.description_coverage_in.should == ["01:00:00;00"]
  # end
  
  # it "has metadata for format" do
  #   @uois.wgbh_format.dimensions_height.should == ["480"]
  #   @uois.wgbh_format.aspect_ratio.should == ["4:3"]
  #   @uois.wgbh_format.broadcast_format.should == ["NTSC"]
  #   @uois.wgbh_format.duration.should == ["00:39:38;10"]
  #   @uois.wgbh_format.color.should == ["Color"]
  #   @uois.wgbh_format.dimensions_width.should == ["720"]
  #   @uois.wgbh_format.item_format.should == ["Betacam"]
  #   @uois.wgbh_format.mime_type.should == ["video/quicktime"]
  # end
  
  # it "has metadata for title" do
  #   @uois.wgbh_title.title_type.should == ["Program", "Series"]
  #   @uois.wgbh_title.title.should == ["Best of the 70's", "ZOOM, Series II"]
  # end
  
  # it "has metadata for annotations" do
  #   @uois.wgbh_annotation.annotation.should == ["(Video Track 1) width/height/depth : 720 / 480 / 24 ", "(Video Track 1) compression format : dv5n Apple DVCPRO50 - NTSC ", "(Audio Track 3) compression format : in24 24-bit Integer ", "(Audio Track 3) bits/channels : 16 / 1 ", "(Audio Track 1) duration : 2378.312 seconds ", "(Audio Track 1) compression format : in24 24-bit Integer ", "/Volumes/bigDisks/Final Cut Pro Documents/Capture Scratch/Zoom/barcode321909.mov", "(Audio Track 6) start time : 0.000 seconds ", "(Audio Track 6) samples per second : 48000 ", "(Audio Track 7) start time : 0.000 seconds ", "(Audio Track 7) duration : 2378.312 seconds ", "(Audio Track 7) compression format : in24 24-bit Integer ", "(Audio Track 7) bits/channels : 16 / 1 ", "(Audio Track 7) samples per second : 48000 ", "(Audio Track 8) start time : 0.000 seconds ", "(Audio Track 8) duration : 2378.312 seconds ", "(Audio Track 8) compression format : in24 24-bit Integer ", "(Audio Track 8) bits/channels : 16 / 1 ", "(Audio Track 6) bits/channels : 16 / 1 ", "(Audio Track 1) start time : 0.000 seconds ", "(Audio Track 1) samples per second : 48000 ", "(Audio Track 2) start time : 0.000 seconds ", "(Audio Track 2) duration : 2378.312 seconds ", "(Audio Track 2) compression format : in24 24-bit Integer ", "(Audio Track 2) bits/channels : 16 / 1 ", "(Audio Track 3) start time : 0.000 seconds ", "(Audio Track 3) duration : 2378.312 seconds ", "(Audio Track 4) start time : 0.000 seconds ", "(Audio Track 4) duration : 2378.312 seconds ", "(Audio Track 4) bits/channels : 16 / 1 ", "(Audio Track 4) samples per second : 48000 ", "(Audio Track 5) start time : 0.000 seconds ", "(Audio Track 1) bits/channels : 16 / 1 ", "(Audio Track 5) duration : 2378.312 seconds ", "(Audio Track 2) samples per second : 48000 ", "(Audio Track 5) compression format : in24 24-bit Integer ", "(Audio Track 5) bits/channels : 16 / 1 ", "(Audio Track 5) samples per second : 48000 ", "(Audio Track 4) compression format : in24 24-bit Integer ", "(Audio Track 3) samples per second : 48000 ", "(Audio Track 6) duration : 2378.312 seconds ", "(Audio Track 6) compression format : in24 24-bit Integer ", "(Video Track 1) start time : 0.000 seconds ", "(Video Track 1) duration : 2378.312 seconds ", "(Video Track 1) frames per second : 29.97 ", "(Audio Track 8) samples per second : 48000 "]
  #   @uois.wgbh_annotation.annotation_type.should == ["Movie Quality", "Movie Quality", "Audio Quality2", "Audio Quality2", "Audio Quality2", "Audio Quality2", "Source", "Audio Quality2", "Audio Quality2", "Audio Quality2", "Audio Quality2", "Audio Quality2", "Audio Quality2", "Audio Quality2", "Audio Quality2", "Audio Quality2", "Audio Quality2", "Audio Quality2", "Audio Quality2", "Audio Quality2", "Audio Quality2", "Audio Quality2", "Audio Quality2", "Audio Quality2", "Audio Quality2", "Audio Quality2", "Audio Quality2", "Audio Quality2", "Audio Quality2", "Audio Quality2", "Audio Quality2", "Audio Quality2", "Audio Quality2", "Audio Quality2", "Audio Quality2", "Audio Quality2", "Audio Quality2", "Audio Quality2", "Audio Quality2", "Audio Quality2", "Audio Quality2", "Audio Quality2", "Movie Quality", "Movie Quality", "Movie Quality", "Audio Quality2"]
  # end
  
  # it "has metadata for source" do
  #   @uois.wgbh_source.source_type.should == ["Tracking Number"]
  #   @uois.wgbh_source.source.should == ["321909"]
  # end
  
  # it "has metadata for language" do
  #   @uois.wgbh_language.language_usage == ["Dialogue"]
  #   @uois.wgbh_language.language.should == ["eng"]
  # end
  
  # it "has metadata for publisher" do
  #   @uois.wgbh_publisher.publisher.should == ["WGBH Educational Foundation"]
  #   @uois.wgbh_publisher.publisher_type.should == ["Publisher"]
  # end
  
  # it "has metadata for holdings" do
  #   @uois.wgbh_holdings.holdings_department.should == ["Archives"]
  # end

end