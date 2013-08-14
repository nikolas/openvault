# encoding: utf-8

require 'spec_helper'

describe Artesia::Datastream::UOIS do

  fixtures = {
    :rock_and_roll => {
      :series_1 => uois_from_fixture("#{fixture_path}/teams_asset_files/rock_and_roll/series_1.xml"),
      :program_1 => uois_from_fixture("#{fixture_path}/teams_asset_files/rock_and_roll/program_1.xml"),
      :video_1 => uois_from_fixture("#{fixture_path}/teams_asset_files/rock_and_roll/video_1.xml"),
      :video_2 => uois_from_fixture("#{fixture_path}/teams_asset_files/rock_and_roll/video_2.xml"),
      :video_3 => uois_from_fixture("#{fixture_path}/teams_asset_files/rock_and_roll/video_3.xml"),
      :image_1 => uois_from_fixture("#{fixture_path}/teams_asset_files/rock_and_roll/image_1.xml"),
      :image_2 => uois_from_fixture("#{fixture_path}/teams_asset_files/rock_and_roll/image_2.xml"),      
      :transcript_1 => uois_from_fixture("#{fixture_path}/teams_asset_files/rock_and_roll/transcript_1.xml")
    },

    :zoom => {
      :series_1 => uois_from_fixture("#{fixture_path}/teams_asset_files/zoom/series_1.xml"),
      :program_1 => uois_from_fixture("#{fixture_path}/teams_asset_files/zoom/program_1.xml"),
      :video_1 => uois_from_fixture("#{fixture_path}/teams_asset_files/zoom/video_1.xml"),
      :video_2 => uois_from_fixture("#{fixture_path}/teams_asset_files/zoom/video_2.xml"),
      :video_3 => uois_from_fixture("#{fixture_path}/teams_asset_files/zoom/video_3.xml"),
      :image_1 => uois_from_fixture("#{fixture_path}/teams_asset_files/zoom/image_1.xml")
    },

    :march_on_washington => {
      :audio_1 => uois_from_fixture("#{fixture_path}/teams_asset_files/march_on_washington/audio_1.xml")
    }
  }

  describe '#is_series?' do
    it 'returns true if <UOIS> xml describes a series' do
      fixtures[:rock_and_roll][:series_1].is_series?.should == true
      fixtures[:zoom][:series_1].is_series?.should == true
    end

    it 'returns false if <UOIS> xml does not describe a series' do
      fixtures[:rock_and_roll][:program_1].is_series?.should == false
      fixtures[:rock_and_roll][:video_1].is_series?.should == false
      fixtures[:rock_and_roll][:video_2].is_series?.should == false
      fixtures[:rock_and_roll][:video_3].is_series?.should == false
      fixtures[:rock_and_roll][:image_1].is_series?.should == false
      fixtures[:rock_and_roll][:image_2].is_series?.should == false
      fixtures[:rock_and_roll][:transcript_1].is_series?.should == false
      fixtures[:zoom][:program_1].is_series?.should == false
      fixtures[:zoom][:video_1].is_series?.should == false
      fixtures[:zoom][:video_2].is_series?.should == false
      fixtures[:zoom][:video_3].is_series?.should == false
      fixtures[:zoom][:image_1].is_series?.should == false
      fixtures[:march_on_washington][:audio_1].is_series?.should == false
    end
  end


  describe '#is_program?' do
    it 'returns true if <UOIS> xml describes a program' do
      fixtures[:rock_and_roll][:program_1].is_program?.should == true
      fixtures[:zoom][:program_1].is_program?.should == true
    end

    # not a program
    it 'returns false if <UOIS> xml does not describe a program' do
      fixtures[:rock_and_roll][:series_1].is_program?.should == false
      fixtures[:rock_and_roll][:video_1].is_program?.should == false
      fixtures[:rock_and_roll][:video_2].is_program?.should == false
      fixtures[:rock_and_roll][:video_3].is_program?.should == false
      fixtures[:rock_and_roll][:image_1].is_program?.should == false
      fixtures[:rock_and_roll][:image_2].is_program?.should == false
      fixtures[:rock_and_roll][:transcript_1].is_program?.should == false

      fixtures[:zoom][:series_1].is_program?.should == false
      fixtures[:zoom][:video_2].is_program?.should == false
      fixtures[:zoom][:video_3].is_program?.should == false
      fixtures[:zoom][:image_1].is_program?.should == false
    end
  end


  describe '#is_video?' do
    it 'returns true if <UOIS> xml describes a video' do
      fixtures[:rock_and_roll][:video_1].is_video?.should == true
      fixtures[:rock_and_roll][:video_2].is_video?.should == true
      fixtures[:rock_and_roll][:video_3].is_video?.should == true
      fixtures[:zoom][:video_1].is_video?.should == true
      fixtures[:zoom][:video_2].is_video?.should == true
      fixtures[:zoom][:video_3].is_video?.should == true
    end

    it 'returns false if <UOIS> xml does not describe a video' do
      fixtures[:rock_and_roll][:series_1].is_video?.should == false
      fixtures[:rock_and_roll][:image_1].is_video?.should == false
      fixtures[:rock_and_roll][:image_2].is_video?.should == false
      fixtures[:rock_and_roll][:transcript_1].is_video?.should == false
      fixtures[:zoom][:series_1].is_video?.should == false
      fixtures[:zoom][:image_1].is_video?.should == false
      fixtures[:march_on_washington][:audio_1].is_video?.should == false
    end
  end


  describe '#is_image?' do
    it 'returns true if <UOIS> xml describes an image' do
      fixtures[:rock_and_roll][:image_1].is_image?.should == true
      fixtures[:rock_and_roll][:image_2].is_image?.should == true
      fixtures[:zoom][:image_1].is_image?.should == true
    end

    it 'returns false if <UOIS> xml does not describe an image' do
      fixtures[:rock_and_roll][:series_1].is_image?.should == false
      fixtures[:rock_and_roll][:program_1].is_image?.should == false
      fixtures[:rock_and_roll][:video_1].is_image?.should == false
      fixtures[:rock_and_roll][:video_2].is_image?.should == false
      fixtures[:rock_and_roll][:video_3].is_image?.should == false
      fixtures[:rock_and_roll][:transcript_1].is_image?.should == false

      fixtures[:zoom][:series_1].is_image?.should == false
      fixtures[:zoom][:program_1].is_image?.should == false
      fixtures[:zoom][:video_2].is_image?.should == false
      fixtures[:zoom][:video_3].is_image?.should == false
      
      fixtures[:march_on_washington][:audio_1].is_image?.should == false
    end
  end


  describe '#is_transcript?' do
    it 'returns true if <UOIS> xml describes a transcript' do
      fixtures[:rock_and_roll][:transcript_1].is_transcript?.should == true
    end

    it 'returns false if <UOIS> xml does not describe a transcript' do
      fixtures[:rock_and_roll][:series_1].is_transcript?.should == false
      fixtures[:rock_and_roll][:program_1].is_transcript?.should == false
      fixtures[:rock_and_roll][:video_1].is_transcript?.should == false
      fixtures[:rock_and_roll][:video_2].is_transcript?.should == false
      fixtures[:rock_and_roll][:video_3].is_transcript?.should == false
      fixtures[:rock_and_roll][:image_1].is_transcript?.should == false
      fixtures[:rock_and_roll][:image_2].is_transcript?.should == false

      fixtures[:zoom][:series_1].is_transcript?.should == false
      fixtures[:zoom][:program_1].is_transcript?.should == false
      fixtures[:zoom][:video_2].is_transcript?.should == false
      fixtures[:zoom][:video_3].is_transcript?.should == false
      fixtures[:zoom][:image_1].is_transcript?.should == false
      
      fixtures[:march_on_washington][:audio_1].is_transcript?.should == false
    end
  end


  describe '#is_audio?' do
    it 'returns true if <UOIS> xml describes audio' do
      fixtures[:march_on_washington][:audio_1].is_audio?.should == true
    end

    it 'returns false if <UOIS> xml does not describe audio' do
      fixtures[:rock_and_roll][:series_1].is_audio?.should == false
      fixtures[:rock_and_roll][:program_1].is_audio?.should == false
      fixtures[:rock_and_roll][:video_1].is_audio?.should == false
      fixtures[:rock_and_roll][:video_2].is_audio?.should == false
      fixtures[:rock_and_roll][:video_3].is_audio?.should == false
      fixtures[:rock_and_roll][:image_1].is_audio?.should == false
      fixtures[:rock_and_roll][:image_2].is_audio?.should == false
      fixtures[:rock_and_roll][:transcript_1].is_audio?.should == false

      fixtures[:zoom][:series_1].is_audio?.should == false
      fixtures[:zoom][:program_1].is_audio?.should == false
      fixtures[:zoom][:video_2].is_audio?.should == false
      fixtures[:zoom][:video_3].is_audio?.should == false
      fixtures[:zoom][:image_1].is_audio?.should == false
    end
  end


  ##
  # Test the terminology
  ##

  describe '#creators, #creators#name, #creators#role' do
    it 'returns all creator role and creator name' do
      fixtures[:rock_and_roll][:series_1].creator.count.should == 2
      fixtures[:rock_and_roll][:series_1].creator.name.should == ["Espar, David", "Deane, Elizabeth"]
      fixtures[:rock_and_roll][:series_1].creator.role.should == ["Senior Producer5000", "Executive Producer5000"]
    end
  end

  describe '#rights, #rights#note, #rights#holder, #rights#credit, #rights#type' do
    it 'returns all values for rights note, rights holder, rights credit, and rights type' do
      fixtures[:zoom][:video_1].rights.count.should == 1
      fixtures[:zoom][:video_1].rights.note.should == ["Media not to be released to Open Vault"]
      fixtures[:zoom][:video_1].rights.holder.should == ["WGBH Educational Foundation"]
      fixtures[:zoom][:video_1].rights.credit.should == ["WGBH Educational Foundation"]
      fixtures[:zoom][:video_1].rights.type.should == ["Web"]
    end
  end


  describe '#subject, #subject#type, #subject#val' do
    it 'returns all values for subject and subject type' do
      fixtures[:zoom][:video_1].subject.value.should == [
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

      fixtures[:zoom][:video_1].subject.type.should == [
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
      fixtures[:rock_and_roll][:video_1].type.count.should == 1
      fixtures[:rock_and_roll][:video_1].type.media.should == ["Moving Image"]
      fixtures[:rock_and_roll][:video_1].type.item.should == ["Original footage"]
    end
  end


  describe '#description, #description#type, #description#coverage, #description#coverage_in, #description#coverage_out, #description#value' do
    it 'returns all values for description type, description coverage, description coverage in, description coverage out, and description value' do
      fixtures[:rock_and_roll][:video_1].description.count.should == 1
      fixtures[:rock_and_roll][:video_1].description.type.should == ["Summary"]
      fixtures[:rock_and_roll][:video_1].description.coverage.should == ["00:21:28:10"]
      fixtures[:rock_and_roll][:video_1].description.coverage_out.should == ["08:21:26:23"]
      fixtures[:rock_and_roll][:video_1].description.coverage_in.should == ["07:59:58:14"]
      fixtures[:rock_and_roll][:video_1].description.value.should == ["Interview with Rufus Thomas [Part 2 of 4]"]
    end
  end

  describe '#format.dimensions_height, #format.aspect_ratio, #format.broadcast_format, #format.duration, #format.color, #format.dimensions_width, #format.item_format, #format.mime_type' do
    it 'returns all values for dimensions height, aspect ratio, broadcast format, duration, color, dimension width, item format, and mime type' do
      fixtures[:rock_and_roll][:video_1].format.count.should == 1
      fixtures[:rock_and_roll][:video_1].format.dimensions_height.should == ["486"]
      fixtures[:rock_and_roll][:video_1].format.aspect_ratio.should == ["4:3"]
      fixtures[:rock_and_roll][:video_1].format.broadcast_format.should == ["NTSC"]
      fixtures[:rock_and_roll][:video_1].format.duration.should == ["00:21:28:10"]
      fixtures[:rock_and_roll][:video_1].format.color.should == ["Color"]
      fixtures[:rock_and_roll][:video_1].format.dimensions_width.should == ["720"]
      fixtures[:rock_and_roll][:video_1].format.item_format.should == ["Betacam"]
      fixtures[:rock_and_roll][:video_1].format.mime_type.should == ["video/quicktime"]
    end
  end

  describe '#title.value, #title.type' do
    it 'returns all values for title and title type' do

    end
  end

  describe '#annotation.value, #annotation.type' do
    it 'returns all values for annotation and annotation type' do
      fixtures[:zoom][:video_2].annotation.count.should == 12
      fixtures[:zoom][:video_2].annotation.value.should == [
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

      fixtures[:zoom][:video_2].annotation.type.should == [
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
      fixtures[:rock_and_roll][:video_1].source.count.should == 3
      fixtures[:rock_and_roll][:video_1].source.value.should == ["10856", "17030028", "104"]
      fixtures[:rock_and_roll][:video_1].source.type.should == ["Tracking Number", "Tape", "Program Number"]
    end
  end

  describe '#language.value, #language.type' do
    it 'returns all values for language and language type' do
      fixtures[:march_on_washington][:audio_1].language.count.should == 1
      fixtures[:march_on_washington][:audio_1].language.value.should == ["eng"]
      fixtures[:march_on_washington][:audio_1].language.usage.should == ["Dialogue"]
    end
  end

  describe '#publisher.value, #publisher.type' do
    it 'returns all values for publisher and publisher type' do
      fixtures[:zoom][:video_3].publisher.count.should == 1
      fixtures[:zoom][:video_3].publisher.value.should == ["WGBH Educational Foundation"]
      fixtures[:zoom][:video_3].publisher.type.should == ["Publisher"]
    end
  end

  describe '#holdings.value, #holdings.type' do
    it 'returns all values for holdings and holdings type' do
      fixtures[:rock_and_roll][:video_1].holdings.count.should == 1
      fixtures[:rock_and_roll][:video_1].holdings.department.should == ["Archives"]
    end
  end

end