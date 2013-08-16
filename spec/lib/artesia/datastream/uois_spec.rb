# encoding: utf-8

require 'spec_helper'
require "#{RSpec.configuration.fixture_path}/artesia/load_fixtures"

describe Artesia::Datastream::UOIS do

  before(:each) { Fixtures.cwd "#{RSpec.configuration.fixture_path}/artesia" }

  describe '#is_series?' do
    it 'returns true if <UOIS> xml describes a series' do
      Fixtures.use("rock_and_roll/series_1.xml").is_series?.should == true
      Fixtures.use("zoom/series_1.xml").is_series?.should == true
    end

    it 'returns false if <UOIS> xml does not describe a series' do
      Fixtures.use("rock_and_roll/program_1.xml").is_series?.should == false
      Fixtures.use("rock_and_roll/video_1.xml").is_series?.should == false
      Fixtures.use("rock_and_roll/video_2.xml").is_series?.should == false
      Fixtures.use("rock_and_roll/video_3.xml").is_series?.should == false
      Fixtures.use("rock_and_roll/image_1.xml").is_series?.should == false
      Fixtures.use("rock_and_roll/image_2.xml").is_series?.should == false
      Fixtures.use("rock_and_roll/transcript_1.xml").is_series?.should == false
      Fixtures.use("zoom/program_1.xml").is_series?.should == false
      Fixtures.use("zoom/video_1.xml").is_series?.should == false
      Fixtures.use("zoom/video_2.xml").is_series?.should == false
      Fixtures.use("zoom/video_3.xml").is_series?.should == false
      Fixtures.use("zoom/image_1.xml").is_series?.should == false
      Fixtures.use("march_on_washington/audio_1.xml").is_series?.should == false
    end
  end


  describe '#is_program?' do
    it 'returns true if <UOIS> xml describes a program' do
      Fixtures.use("rock_and_roll/program_1.xml").is_program?.should == true
      Fixtures.use("zoom/program_1.xml").is_program?.should == true
    end

    # not a program
    it 'returns false if <UOIS> xml does not describe a program' do
      Fixtures.use("rock_and_roll/series_1.xml").is_program?.should == false
      Fixtures.use("rock_and_roll/video_1.xml").is_program?.should == false
      Fixtures.use("rock_and_roll/video_2.xml").is_program?.should == false
      Fixtures.use("rock_and_roll/video_3.xml").is_program?.should == false
      Fixtures.use("rock_and_roll/image_1.xml").is_program?.should == false
      Fixtures.use("rock_and_roll/image_2.xml").is_program?.should == false
      Fixtures.use("rock_and_roll/transcript_1.xml").is_program?.should == false

      Fixtures.use("zoom/series_1.xml").is_program?.should == false
      Fixtures.use("zoom/video_2.xml").is_program?.should == false
      Fixtures.use("zoom/video_3.xml").is_program?.should == false
      Fixtures.use("zoom/image_1.xml").is_program?.should == false
    end
  end


  describe '#is_video?' do
    it 'returns true if <UOIS> xml describes a video' do
      Fixtures.use("rock_and_roll/video_1.xml").is_video?.should == true
      Fixtures.use("rock_and_roll/video_2.xml").is_video?.should == true
      Fixtures.use("rock_and_roll/video_3.xml").is_video?.should == true
      Fixtures.use("zoom/video_1.xml").is_video?.should == true
      Fixtures.use("zoom/video_2.xml").is_video?.should == true
      Fixtures.use("zoom/video_3.xml").is_video?.should == true
    end

    it 'returns false if <UOIS> xml does not describe a video' do
      Fixtures.use("rock_and_roll/series_1.xml").is_video?.should == false
      Fixtures.use("rock_and_roll/image_1.xml").is_video?.should == false
      Fixtures.use("rock_and_roll/image_2.xml").is_video?.should == false
      Fixtures.use("rock_and_roll/transcript_1.xml").is_video?.should == false
      Fixtures.use("zoom/series_1.xml").is_video?.should == false
      Fixtures.use("zoom/image_1.xml").is_video?.should == false
      Fixtures.use("march_on_washington/audio_1.xml").is_video?.should == false
    end
  end


  describe '#is_image?' do
    it 'returns true if <UOIS> xml describes an image' do
      Fixtures.use("rock_and_roll/image_1.xml").is_image?.should == true
      Fixtures.use("rock_and_roll/image_2.xml").is_image?.should == true
      Fixtures.use("zoom/image_1.xml").is_image?.should == true
    end

    it 'returns false if <UOIS> xml does not describe an image' do
      Fixtures.use("rock_and_roll/series_1.xml").is_image?.should == false
      Fixtures.use("rock_and_roll/program_1.xml").is_image?.should == false
      Fixtures.use("rock_and_roll/video_1.xml").is_image?.should == false
      Fixtures.use("rock_and_roll/video_2.xml").is_image?.should == false
      Fixtures.use("rock_and_roll/video_3.xml").is_image?.should == false
      Fixtures.use("rock_and_roll/transcript_1.xml").is_image?.should == false

      Fixtures.use("zoom/series_1.xml").is_image?.should == false
      Fixtures.use("zoom/program_1.xml").is_image?.should == false
      Fixtures.use("zoom/video_2.xml").is_image?.should == false
      Fixtures.use("zoom/video_3.xml").is_image?.should == false
      
      Fixtures.use("march_on_washington/audio_1.xml").is_image?.should == false
    end
  end


  describe '#is_transcript?' do
    it 'returns true if <UOIS> xml describes a transcript' do
      Fixtures.use("rock_and_roll/transcript_1.xml").is_transcript?.should == true
    end

    it 'returns false if <UOIS> xml does not describe a transcript' do
      Fixtures.use("rock_and_roll/series_1.xml").is_transcript?.should == false
      Fixtures.use("rock_and_roll/program_1.xml").is_transcript?.should == false
      Fixtures.use("rock_and_roll/video_1.xml").is_transcript?.should == false
      Fixtures.use("rock_and_roll/video_2.xml").is_transcript?.should == false
      Fixtures.use("rock_and_roll/video_3.xml").is_transcript?.should == false
      Fixtures.use("rock_and_roll/image_1.xml").is_transcript?.should == false
      Fixtures.use("rock_and_roll/image_2.xml").is_transcript?.should == false

      Fixtures.use("zoom/series_1.xml").is_transcript?.should == false
      Fixtures.use("zoom/program_1.xml").is_transcript?.should == false
      Fixtures.use("zoom/video_2.xml").is_transcript?.should == false
      Fixtures.use("zoom/video_3.xml").is_transcript?.should == false
      Fixtures.use("zoom/image_1.xml").is_transcript?.should == false
      
      Fixtures.use("march_on_washington/audio_1.xml").is_transcript?.should == false
    end
  end


  describe '#is_audio?' do
    it 'returns true if <UOIS> xml describes audio' do
      Fixtures.use("march_on_washington/audio_1.xml").is_audio?.should == true
    end

    it 'returns false if <UOIS> xml does not describe audio' do
      Fixtures.use("rock_and_roll/series_1.xml").is_audio?.should == false
      Fixtures.use("rock_and_roll/program_1.xml").is_audio?.should == false
      Fixtures.use("rock_and_roll/video_1.xml").is_audio?.should == false
      Fixtures.use("rock_and_roll/video_2.xml").is_audio?.should == false
      Fixtures.use("rock_and_roll/video_3.xml").is_audio?.should == false
      Fixtures.use("rock_and_roll/image_1.xml").is_audio?.should == false
      Fixtures.use("rock_and_roll/image_2.xml").is_audio?.should == false
      Fixtures.use("rock_and_roll/transcript_1.xml").is_audio?.should == false

      Fixtures.use("zoom/series_1.xml").is_audio?.should == false
      Fixtures.use("zoom/program_1.xml").is_audio?.should == false
      Fixtures.use("zoom/video_2.xml").is_audio?.should == false
      Fixtures.use("zoom/video_3.xml").is_audio?.should == false
      Fixtures.use("zoom/image_1.xml").is_audio?.should == false
    end
  end


  ##
  # Test the terminology
  ##

  describe '#creators, #creators#name, #creators#role' do
    it 'returns all creator role and creator name' do
      Fixtures.use("rock_and_roll/series_1.xml").creator.count.should == 2
      Fixtures.use("rock_and_roll/series_1.xml").creator.name.should == ["Espar, David", "Deane, Elizabeth"]
      Fixtures.use("rock_and_roll/series_1.xml").creator.role.should == ["Senior Producer5000", "Executive Producer5000"]
    end
  end

  describe '#rights, #rights#note, #rights#holder, #rights#credit, #rights#type' do
    it 'returns all values for rights note, rights holder, rights credit, and rights type' do
      Fixtures.use("zoom/video_1.xml").rights.count.should == 1
      Fixtures.use("zoom/video_1.xml").rights.note.should == ["Media not to be released to Open Vault"]
      Fixtures.use("zoom/video_1.xml").rights.holder.should == ["WGBH Educational Foundation"]
      Fixtures.use("zoom/video_1.xml").rights.credit.should == ["WGBH Educational Foundation"]
      Fixtures.use("zoom/video_1.xml").rights.type.should == ["Web"]
    end
  end


  describe '#subject, #subject#type, #subject#val' do
    it 'returns all values for subject and subject type' do
      Fixtures.use("zoom/video_1.xml").subject.value.should == [
        "Preteens",
        "Variety shows (Television programs)",
        "Zoom (Television program : WGBH (Television station : Boston, Mass.))",
        "Children's television programs--United States",
        "Children",
        "Play",
        "Children's television programs",
        "Games",
        "Amusements"
      ]

      Fixtures.use("zoom/video_1.xml").subject.type.should == [
        "Subject Heading",
        "Subject Heading",
        "Corporate",
        "Subject Heading",
        "Subject Heading",
        "Subject Heading",
        "Subject Heading",
        "Subject Heading",
        "Subject Heading"
      ]
    end
  end

  describe '#type, #type#media, #type#item' do
    it 'returns all values for type, media type, and item type' do
      Fixtures.use("rock_and_roll/video_1.xml").type.count.should == 1
      Fixtures.use("rock_and_roll/video_1.xml").type.media.should == ["Moving Image"]
      Fixtures.use("rock_and_roll/video_1.xml").type.item.should == ["Original footage"]
    end
  end


  describe '#description, #description#type, #description#coverage, #description#coverage_in, #description#coverage_out, #description#value' do
    it 'returns all values for description type, description coverage, description coverage in, description coverage out, and description value' do
      Fixtures.use("rock_and_roll/video_1.xml").description.count.should == 1
      Fixtures.use("rock_and_roll/video_1.xml").description.type.should == ["Summary"]
      Fixtures.use("rock_and_roll/video_1.xml").description.coverage.should == ["00:21:28:10"]
      Fixtures.use("rock_and_roll/video_1.xml").description.coverage_out.should == ["08:21:26:23"]
      Fixtures.use("rock_and_roll/video_1.xml").description.coverage_in.should == ["07:59:58:14"]
      Fixtures.use("rock_and_roll/video_1.xml").description.value.should == ["Interview with Rufus Thomas [Part 2 of 4]"]
    end
  end

  describe '#format.dimensions_height, #format.aspect_ratio, #format.broadcast_format, #format.duration, #format.color, #format.dimensions_width, #format.item_format, #format.mime_type' do
    it 'returns all values for dimensions height, aspect ratio, broadcast format, duration, color, dimension width, item format, and mime type' do
      Fixtures.use("rock_and_roll/video_1.xml").format.count.should == 1
      Fixtures.use("rock_and_roll/video_1.xml").format.dimensions_height.should == ["486"]
      Fixtures.use("rock_and_roll/video_1.xml").format.aspect_ratio.should == ["4:3"]
      Fixtures.use("rock_and_roll/video_1.xml").format.broadcast_format.should == ["NTSC"]
      Fixtures.use("rock_and_roll/video_1.xml").format.duration.should == ["00:21:28:10"]
      Fixtures.use("rock_and_roll/video_1.xml").format.color.should == ["Color"]
      Fixtures.use("rock_and_roll/video_1.xml").format.dimensions_width.should == ["720"]
      Fixtures.use("rock_and_roll/video_1.xml").format.item_format.should == ["Betacam"]
      Fixtures.use("rock_and_roll/video_1.xml").format.mime_type.should == ["video/quicktime"]
    end
  end

  describe '#title.value, #title.type' do
    it 'returns all values for title and title type' do

    end
  end

  describe '#annotation.value, #annotation.type' do
    it 'returns all values for annotation and annotation type' do
      Fixtures.use("zoom/video_2.xml").annotation.count.should == 12
      Fixtures.use("zoom/video_2.xml").annotation.value.should == [
        "(Video Track 1) duration : 29.496 seconds ",
        "(Video Track 1) frames per second : 29.97 ",
        "(Video Track 1) compression format : avc1 H.264 ",
        "(Video Track 1) width/height/depth : 320 / 240 / 24 ",
        "(Audio Track 1) start time : 0.000 seconds ",
        "(Audio Track 1) duration : 29.496 seconds ",
        "(Audio Track 1) compression format : mp4a MPEG-4 Audio ",
        "(Audio Track 1) bits/channels : 16 / 2 ",
        "/Volumes/bigDisks/Muraszko Projects/Watermarked Programs/Pledge_Zoom_Bernadette.mp4",
        "Watermarked Mp4 for web",
        "(Audio Track 1) samples per second : 48000 ",
        "(Video Track 1) start time : 0.000 seconds "
      ]

      Fixtures.use("zoom/video_2.xml").annotation.type.should == [
        "Movie Quality",
        "Movie Quality",
        "Movie Quality",
        "Movie Quality",
        "Audio Quality2",
        "Audio Quality2",
        "Audio Quality2",
        "Audio Quality2",
        "Source",
        "Versioning",
        "Audio Quality2",
        "Movie Quality"
      ]
    end
  end

  describe '#source.value, #source.type' do
    it 'returns all values for source and source type' do
      Fixtures.use("rock_and_roll/video_1.xml").source.count.should == 3
      Fixtures.use("rock_and_roll/video_1.xml").source.value.should == ["10856", "17030028", "104"]
      Fixtures.use("rock_and_roll/video_1.xml").source.type.should == ["Tracking Number", "Tape", "Program Number"]
    end
  end

  describe '#language.value, #language.type' do
    it 'returns all values for language and language type' do
      Fixtures.use("march_on_washington/audio_1.xml").language.count.should == 1
      Fixtures.use("march_on_washington/audio_1.xml").language.value.should == ["eng"]
      Fixtures.use("march_on_washington/audio_1.xml").language.usage.should == ["Dialogue"]
    end
  end

  describe '#publisher.value, #publisher.type' do
    it 'returns all values for publisher and publisher type' do
      Fixtures.use("zoom/video_3.xml").publisher.count.should == 1
      Fixtures.use("zoom/video_3.xml").publisher.value.should == ["WGBH Educational Foundation"]
      Fixtures.use("zoom/video_3.xml").publisher.type.should == ["Publisher"]
    end
  end

  describe '#holdings.value, #holdings.type' do
    it 'returns all values for holdings and holdings type' do
      Fixtures.use("rock_and_roll/video_1.xml").holdings.count.should == 1
      Fixtures.use("rock_and_roll/video_1.xml").holdings.department.should == ["Archives"]
    end
  end

end