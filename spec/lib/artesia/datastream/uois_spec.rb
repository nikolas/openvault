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

  # all creators
  describe '#creators' do
    it 'returns all creators with role name' do
      Fixtures.use("rock_and_roll/series_1.xml").creators.count.should == 2
      Fixtures.use("rock_and_roll/series_1.xml").creators.name.should == ["Espar, David", "Deane, Elizabeth"]
      Fixtures.use("rock_and_roll/series_1.xml").creators.role.should == ["Senior Producer5000", "Executive Producer5000"]
    end
  end

  # specific creator roles
  describe '#artists' do
    it 'returns the names of all artists' do
      Fixtures.use("patriots_day/image_2.xml").artists.should == ["Ritchie, A.H."]
    end
  end

  describe '#directors' do
    it 'returns the names of all directors' do
      Fixtures.use('patriots_day/audio_2.xml').directors.should == ["Atwood, David"]
      Fixtures.use('patriots_day/video_2.xml').directors.should == ["Barzyk, Fred"]
    end
  end

  describe '#producers' do
    it 'returns the names of producers (whose title is just "Producer", i.e. not "Executive Producer", "Senior Producer", etc)' do
      Fixtures.use('patriots_day/audio_2.xml').producers.should == ["Morash, Russell"]
    end
  end

  describe '#senior_producers' do
    it 'returns the names of senior producers' do
      Fixtures.use('rock_and_roll/series_1.xml').senior_producers.should == ["Espar, David"]
    end
  end

  describe '#exec_producers' do
    it 'returns the names of executivce producers' do
      Fixtures.use('rock_and_roll/series_1.xml').exec_producers.should == ["Deane, Elizabeth"]
    end
  end

  describe '#all_producers' do
    it 'returns the names of all producers, executive producers, and senior producers' do
      Fixtures.use('generic/wgbh_creators.xml').all_producers.should == [
        "Test Executive Producer 2",
        "Test Executive Producer 5000",
        "Test Producer",
        "Test Senior Producer 5000"
      ]
    end
  end


  # Subjects
  describe '#subjects' do
    it 'returns all subjects with their values and types' do

      # test the types.
      Fixtures.use('generic/wgbh_subjects.xml').subjects.type.should == [
        "Corporate",
        "Geographical",
        "Keyword",
        "Personal",
        "Personalities",
        "Subject Heading",
        "Topical"
      ]

      # test the values.
      Fixtures.use('generic/wgbh_subjects.xml').subjects.value.should == [
        "Test Corporate Subject",
        "Test Geographical Subject",
        "Test Keyword Subject",
        "Test Personal Subject",
        "Test Personalities Subject",
        "Test Subject Heading Subject",
        "Test Topical Subject"
      ]
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

  describe '#titles' do
    it  'returns all titles, with types and values' do
      Fixtures.use('generic/wgbh_titles.xml').titles.count.should == 12
      Fixtures.use('generic/wgbh_titles.xml').titles.type.should == [
        "Series",
        "Program",
        "Collection",
        "Episode",
        "Element2",
        "Element3",
        "Element4",
        "Item2",
        "Item3",
        "Item4",
        "Clip",
        "Segment"
      ]

      Fixtures.use('generic/wgbh_titles.xml').titles.value.should == [
        "Test Series Title",
        "Test Program Title",
        "Test Collection Title",
        "Test Episode Title",
        "Test Element 2 Title",
        "Test Element 3 Title",
        "Test Element 4 Title",
        "Test Item 2 Title",
        "Test Item 3 Title",
        "Test Item 4 Title",
        "Test Clip Title",
        "Test Segment Title"
      ]
    end
  end

  describe '#series_titles' do
    it 'returns the series titles.' do
      Fixtures.use('generic/wgbh_titles.xml').series_titles.should == ["Test Series Title"]
    end
  end

  describe '#subseries_titles' do
    it 'returns the subseries titles.' do
      Fixtures.use('patriots_day/video_1.xml').subseries_titles.should == ["Rear Bumpers"]
    end
  end

  describe '#program_titles' do
    it 'returns the program titles.' do
      Fixtures.use('generic/wgbh_titles.xml').program_titles.should == ["Test Program Title"]
    end
  end

  describe '#collection_titles' do
    it 'returns the collection titles.' do
      Fixtures.use('generic/wgbh_titles.xml').collection_titles.should == ["Test Collection Title"]
    end
  end

  describe '#episode_titles' do
    it 'returns the episode titles.' do
      Fixtures.use('generic/wgbh_titles.xml').episode_titles.should == ["Test Episode Title"]
    end
  end

  describe '#element_titles' do
    it 'returns the element titles.' do
      Fixtures.use('generic/wgbh_titles.xml').element_titles.should == ["Test Element 2 Title", "Test Element 3 Title", "Test Element 4 Title"]
    end
  end

  describe '#item_titles' do
    it 'returns the item titles.' do
      Fixtures.use('generic/wgbh_titles.xml').item_titles.should == ["Test Item 2 Title", "Test Item 3 Title", "Test Item 4 Title"]
    end
  end

  describe '#clip_titles' do
    it 'returns the clip titles.' do
      Fixtures.use('generic/wgbh_titles.xml').clip_titles.should == ["Test Clip Title"]
    end
  end

  describe '#media_types' do
    it 'returns the media types.' do
      Fixtures.use('rock_and_roll/video_1.xml').media_types.should == ["Moving Image"]
    end
  end

  describe '#types' do
    it 'returns the types of thing the UOIS metadata is describing.' do
      Fixtures.use('rock_and_roll/video_1.xml').types.should == ["Original footage"]
    end
  end

  describe '#publishers' do
    it 'returns value for the publisher.' do
      Fixtures.use("zoom/video_1.xml").publishers.should == ["WGBH Educational Foundation"]
    end
  end

  describe '#copyright_holders' do
    it 'returns the values for copyright holdeers.' do
      Fixtures.use('patriots_day/image_1.xml').copyright_holders.should == ["Harvard Universiry Archives"]
    end
  end

  describe '#distributors' do
    it 'returns the values for distributors.' do
      Fixtures.use('patriots_day/video_1.xml').distributors.should == ["WGBH Educational Foundation"]
    end
  end

end