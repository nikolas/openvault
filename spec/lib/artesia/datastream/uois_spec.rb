# encoding: utf-8

require 'spec_helper'
require "#{RSpec.configuration.fixture_path}/artesia/load_fixtures"

describe Artesia::Datastream::UOIS do

  before(:each) { Fixtures.cwd "#{RSpec.configuration.fixture_path}/artesia" }

  describe '#is_series?' do
    it 'returns true if <UOIS> xml describes a series' do
      Fixtures.use("rock_and_roll/series_1.xml").uois.is_series?.should == true
      Fixtures.use("zoom/series_1.xml").uois.is_series?.should == true
    end

    it 'returns false if <UOIS> xml does not describe a series' do
      Fixtures.use("rock_and_roll/program_1.xml").uois.is_series?.should == false
      Fixtures.use("rock_and_roll/video_element_1.xml").uois.is_series?.should == false
      Fixtures.use("rock_and_roll/video_2.xml").uois.is_series?.should == false
      Fixtures.use("rock_and_roll/video_3.xml").uois.is_series?.should == false
      Fixtures.use("rock_and_roll/image_1.xml").uois.is_series?.should == false
      Fixtures.use("rock_and_roll/image_2.xml").uois.is_series?.should == false
      Fixtures.use("rock_and_roll/transcript_1.xml").uois.is_series?.should == false
      Fixtures.use("zoom/program_1.xml").uois.is_series?.should == false
      Fixtures.use("zoom/video_1.xml").uois.is_series?.should == false
      Fixtures.use("zoom/video_clip_1.xml").uois.is_series?.should == false
      Fixtures.use("zoom/video_clip_2.xml").uois.is_series?.should == false
      Fixtures.use("zoom/image_1.xml").uois.is_series?.should == false
      Fixtures.use("march_on_washington/audio_1.xml").uois.is_series?.should == false
    end
  end


  describe '#is_program?' do
    it 'returns true if <UOIS> xml describes a program' do
      Fixtures.use("rock_and_roll/program_1.xml").uois.is_program?.should == true
      Fixtures.use("zoom/program_1.xml").uois.is_program?.should == true
    end

    # not a program
    it 'returns false if <UOIS> xml does not describe a program' do
      Fixtures.use("rock_and_roll/series_1.xml").uois.is_program?.should == false
      Fixtures.use("rock_and_roll/video_element_1.xml").uois.is_program?.should == false
      Fixtures.use("rock_and_roll/video_2.xml").uois.is_program?.should == false
      Fixtures.use("rock_and_roll/video_3.xml").uois.is_program?.should == false
      Fixtures.use("rock_and_roll/image_1.xml").uois.is_program?.should == false
      Fixtures.use("rock_and_roll/image_2.xml").uois.is_program?.should == false
      Fixtures.use("rock_and_roll/transcript_1.xml").uois.is_program?.should == false

      Fixtures.use("zoom/series_1.xml").uois.is_program?.should == false
      Fixtures.use("zoom/video_clip_1.xml").uois.is_program?.should == false
      Fixtures.use("zoom/video_clip_2.xml").uois.is_program?.should == false
      Fixtures.use("zoom/image_1.xml").uois.is_program?.should == false
    end
  end


  describe '#is_video?' do
    it 'returns true if <UOIS> xml describes a video' do
      Fixtures.use("rock_and_roll/video_element_1.xml").uois.is_video?.should == true
      Fixtures.use("rock_and_roll/video_2.xml").uois.is_video?.should == true
      Fixtures.use("rock_and_roll/video_3.xml").uois.is_video?.should == true
      Fixtures.use("zoom/video_1.xml").uois.is_video?.should == true
      Fixtures.use("zoom/video_clip_1.xml").uois.is_video?.should == true
      Fixtures.use("zoom/video_clip_2.xml").uois.is_video?.should == true
    end

    it 'returns false if <UOIS> xml does not describe a video' do
      Fixtures.use("rock_and_roll/series_1.xml").uois.is_video?.should == false
      Fixtures.use("rock_and_roll/image_1.xml").uois.is_video?.should == false
      Fixtures.use("rock_and_roll/image_2.xml").uois.is_video?.should == false
      Fixtures.use("rock_and_roll/transcript_1.xml").uois.is_video?.should == false
      Fixtures.use("zoom/series_1.xml").uois.is_video?.should == false
      Fixtures.use("zoom/image_1.xml").uois.is_video?.should == false
      Fixtures.use("march_on_washington/audio_1.xml").uois.is_video?.should == false
    end
  end


  describe '#is_image?' do
    it 'returns true if <UOIS> xml describes an image' do
      Fixtures.use("rock_and_roll/image_1.xml").uois.is_image?.should == true
      Fixtures.use("rock_and_roll/image_2.xml").uois.is_image?.should == true
      Fixtures.use("zoom/image_1.xml").uois.is_image?.should == true
    end

    it 'returns false if <UOIS> xml does not describe an image' do
      Fixtures.use("rock_and_roll/series_1.xml").uois.is_image?.should == false
      Fixtures.use("rock_and_roll/program_1.xml").uois.is_image?.should == false
      Fixtures.use("rock_and_roll/video_element_1.xml").uois.is_image?.should == false
      Fixtures.use("rock_and_roll/video_2.xml").uois.is_image?.should == false
      Fixtures.use("rock_and_roll/video_3.xml").uois.is_image?.should == false
      Fixtures.use("rock_and_roll/transcript_1.xml").uois.is_image?.should == false

      Fixtures.use("zoom/series_1.xml").uois.is_image?.should == false
      Fixtures.use("zoom/program_1.xml").uois.is_image?.should == false
      Fixtures.use("zoom/video_clip_1.xml").uois.is_image?.should == false
      Fixtures.use("zoom/video_clip_2.xml").uois.is_image?.should == false
      
      Fixtures.use("march_on_washington/audio_1.xml").uois.is_image?.should == false
    end
  end


  describe '#is_transcript?' do
    it 'returns true if <UOIS> xml describes a transcript' do
      Fixtures.use("rock_and_roll/transcript_1.xml").uois.is_transcript?.should == true
    end

    it 'returns false if <UOIS> xml does not describe a transcript' do
      Fixtures.use("rock_and_roll/series_1.xml").uois.is_transcript?.should == false
      Fixtures.use("rock_and_roll/program_1.xml").uois.is_transcript?.should == false
      Fixtures.use("rock_and_roll/video_element_1.xml").uois.is_transcript?.should == false
      Fixtures.use("rock_and_roll/video_2.xml").uois.is_transcript?.should == false
      Fixtures.use("rock_and_roll/video_3.xml").uois.is_transcript?.should == false
      Fixtures.use("rock_and_roll/image_1.xml").uois.is_transcript?.should == false
      Fixtures.use("rock_and_roll/image_2.xml").uois.is_transcript?.should == false

      Fixtures.use("zoom/series_1.xml").uois.is_transcript?.should == false
      Fixtures.use("zoom/program_1.xml").uois.is_transcript?.should == false
      Fixtures.use("zoom/video_clip_1.xml").uois.is_transcript?.should == false
      Fixtures.use("zoom/video_clip_2.xml").uois.is_transcript?.should == false
      Fixtures.use("zoom/image_1.xml").uois.is_transcript?.should == false
      
      Fixtures.use("march_on_washington/audio_1.xml").uois.is_transcript?.should == false
    end
  end


  describe '#is_audio?' do
    it 'returns true if <UOIS> xml describes audio' do
      Fixtures.use("march_on_washington/audio_1.xml").uois.is_audio?.should == true
    end

    it 'returns false if <UOIS> xml does not describe audio' do
      Fixtures.use("rock_and_roll/series_1.xml").uois.is_audio?.should == false
      Fixtures.use("rock_and_roll/program_1.xml").uois.is_audio?.should == false
      Fixtures.use("rock_and_roll/video_element_1.xml").uois.is_audio?.should == false
      Fixtures.use("rock_and_roll/video_2.xml").uois.is_audio?.should == false
      Fixtures.use("rock_and_roll/video_3.xml").uois.is_audio?.should == false
      Fixtures.use("rock_and_roll/image_1.xml").uois.is_audio?.should == false
      Fixtures.use("rock_and_roll/image_2.xml").uois.is_audio?.should == false
      Fixtures.use("rock_and_roll/transcript_1.xml").uois.is_audio?.should == false

      Fixtures.use("zoom/series_1.xml").uois.is_audio?.should == false
      Fixtures.use("zoom/program_1.xml").uois.is_audio?.should == false
      Fixtures.use("zoom/video_clip_1.xml").uois.is_audio?.should == false
      Fixtures.use("zoom/video_clip_2.xml").uois.is_audio?.should == false
      Fixtures.use("zoom/image_1.xml").uois.is_audio?.should == false
    end
  end


  ##
  # Test the terminology
  #

  ##
  # Creators
  # 
  describe '#creators' do
    it 'returns all creators with role name' do
      Fixtures.use("rock_and_roll/series_1.xml").uois.creators.count.should == 2
      Fixtures.use("rock_and_roll/series_1.xml").uois.creators.name.should == ["Espar, David", "Deane, Elizabeth"]
      Fixtures.use("rock_and_roll/series_1.xml").uois.creators.role.should == ["Senior Producer5000", "Executive Producer5000"]
    end
  end

  # specific creator roles
  describe '#artists' do
    it 'returns the names of all artists' do
      Fixtures.use("patriots_day/image_2.xml").uois.artists.should == ["Ritchie, A.H."]
    end
  end

  describe '#directors' do
    it 'returns the names of all directors' do
      Fixtures.use('patriots_day/audio_2.xml').uois.directors.should == ["Atwood, David"]
      Fixtures.use('patriots_day/video_2.xml').uois.directors.should == ["Barzyk, Fred"]
    end
  end

  describe '#producers' do
    it 'returns the names of producers (whose title is just "Producer", i.e. not "Executive Producer", "Senior Producer", etc)' do
      Fixtures.use('patriots_day/audio_2.xml').uois.producers.should == ["Morash, Russell"]
    end
  end

  describe '#senior_producers' do
    it 'returns the names of senior producers' do
      Fixtures.use('rock_and_roll/series_1.xml').uois.senior_producers.should == ["Espar, David"]
    end
  end

  describe '#exec_producers' do
    it 'returns the names of executivce producers' do
      Fixtures.use('rock_and_roll/series_1.xml').uois.exec_producers.should == ["Deane, Elizabeth"]
    end
  end

  describe '#all_producers' do
    it 'returns the names of all producers, executive producers, and senior producers' do
      Fixtures.use('generic/wgbh_creators.xml').uois.all_producers.should == [
        "Test Executive Producer 2",
        "Test Executive Producer 5000",
        "Test Producer",
        "Test Senior Producer 5000"
      ]
    end
  end


  ##
  # All subjects
  #
  describe '#subjects' do
    it 'returns all subjects with their values and types' do

      # test the types.
      Fixtures.use('generic/wgbh_subjects.xml').uois.subjects.type.should == [
        "Corporate",
        "Geographical",
        "Keyword",
        "Personal",
        "Personalities",
        "Subject Heading",
        "Topical"
      ]

      # test the values.
      Fixtures.use('generic/wgbh_subjects.xml').uois.subjects.value.should == [
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

  ##
  # Specific subjects
  #

  describe '#subjects_corporate' do
    it 'returns the values for corporate subjects' do
      Fixtures.use('generic/wgbh_subjects.xml').uois.subjects_corporate.should == ["Test Corporate Subject"]
    end
  end

  describe '#subjects_geographical' do
    it 'returns the values for geographical subjects' do
      Fixtures.use('generic/wgbh_subjects.xml').uois.subjects_geographical.should == ["Test Geographical Subject"]
    end
  end

  describe '#subjects_topical' do
    it 'returns the values for topical subjects' do
      Fixtures.use('generic/wgbh_subjects.xml').uois.subjects_topical.should == ["Test Topical Subject"]
    end
  end

  describe '#subjects_keywords' do
    it 'returns the values for keywords subjects' do
      Fixtures.use('generic/wgbh_subjects.xml').uois.subjects_keywords.should == ["Test Keyword Subject"]
    end
  end

  describe '#subjects_personalities' do
    it 'returns the values for personalities subjects' do
      Fixtures.use('generic/wgbh_subjects.xml').uois.subjects_personalities.should == ["Test Personalities Subject"]
    end
  end

  describe '#subjects_personal' do
    it 'returns the values for personal subjects' do
      Fixtures.use('generic/wgbh_subjects.xml').uois.subjects_personal.should == ["Test Personal Subject"]
    end
  end

  describe '#subjects_headings' do
    it 'returns the values for headings subjects' do
      Fixtures.use('generic/wgbh_subjects.xml').uois.subjects_headings.should == ["Test Subject Heading Subject"]
    end
  end

  ##
  # Descriptions
  #

  describe '#descriptions' do
    it 'returns all descriptions' do
      Fixtures.use("rock_and_roll/video_element_1.xml").uois.descriptions.should == ["Interview with Rufus Thomas [Part 2 of 4]"]
    end
  end

  ##
  # Coverage
  #

  describe '#coverage' do
    it 'returns the coverage (i.e. the time length of of the media file)' do
      Fixtures.use("rock_and_roll/video_element_1.xml").uois.coverage.should == ["00:21:28:10"]
    end
  end

  describe '#coverage_in' do
    it 'returns the coverge in (i.e. the start time of a clip, element, or segment in the context of a larger media file)' do
      Fixtures.use("rock_and_roll/video_element_1.xml").uois.coverage_in.should == ["07:59:58:14"]
    end
  end

  describe '#coverage_out' do
    it 'returns the coverge out (i.e. the ending time of a clip, element, or segment in the context of a larger media file)' do
      Fixtures.use("rock_and_roll/video_element_1.xml").uois.coverage_out.should == ["08:21:26:23"]
    end
  end

  ##
  # Titles
  #
  describe '#titles' do
    it  'returns all titles, with types and values' do
      Fixtures.use('generic/wgbh_titles.xml').uois.titles.count.should == 13
      Fixtures.use('generic/wgbh_titles.xml').uois.titles.type.should == [
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
        "Segment",
        "Image"
      ]

      Fixtures.use('generic/wgbh_titles.xml').uois.titles.value.should == [
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
        "Test Segment Title",
        "Test Image Title"
      ]
    end
  end

  ##
  # Specific titles
  # 

  describe '#series_titles' do
    it 'returns the series titles.' do
      Fixtures.use('generic/wgbh_titles.xml').uois.series_titles.should == ["Test Series Title"]
    end
  end

  describe '#subseries_titles' do
    it 'returns the subseries titles.' do
      Fixtures.use('patriots_day/video_1.xml').uois.subseries_titles.should == ["Rear Bumpers"]
    end
  end

  describe '#program_titles' do
    it 'returns the program titles.' do
      Fixtures.use('generic/wgbh_titles.xml').uois.program_titles.should == ["Test Program Title"]
    end
  end

  describe '#collection_titles' do
    it 'returns the collection titles.' do
      Fixtures.use('generic/wgbh_titles.xml').uois.collection_titles.should == ["Test Collection Title"]
    end
  end

  describe '#episode_titles' do
    it 'returns the episode titles.' do
      Fixtures.use('generic/wgbh_titles.xml').uois.episode_titles.should == ["Test Episode Title"]
    end
  end

  describe '#element_titles' do
    it 'returns the element titles.' do
      Fixtures.use('generic/wgbh_titles.xml').uois.element_titles.should == ["Test Element 2 Title", "Test Element 3 Title", "Test Element 4 Title"]
    end
  end

  describe '#item_titles' do
    it 'returns the item titles.' do
      Fixtures.use('generic/wgbh_titles.xml').uois.item_titles.should == ["Test Item 2 Title", "Test Item 3 Title", "Test Item 4 Title"]
    end
  end

  describe '#image_titles' do
    it 'returns the image titles' do
      Fixtures.use('generic/wgbh_titles.xml').uois.image_titles.should == ["Test Image Title"]
    end
  end

  describe '#clip_titles' do
    it 'returns the clip titles.' do
      Fixtures.use('generic/wgbh_titles.xml').uois.clip_titles.should == ["Test Clip Title"]
    end
  end

  ##
  # Types of media
  #

  describe '#media_types' do
    it 'returns the media types.' do
      Fixtures.use('rock_and_roll/video_element_1.xml').uois.media_types.should == ["Moving Image"]
    end
  end

  describe '#types' do
    it 'returns the types of thing the UOIS metadata is describing.' do
      Fixtures.use('rock_and_roll/video_element_1.xml').uois.types.should == ["Original footage"]
    end
  end


  ##
  # Creators, names and roles
  #
  describe '#publishers' do
    context 'when PUBLISHER_TYPE="Publisher" in the UOIS xml' do
      it 'returns publisher name and type.' do
        Fixtures.use("zoom/video_1.xml").uois.publishers.name == ["WGBH Educational Foundation"]
        Fixtures.use("zoom/video_1.xml").uois.publishers.type == ["Publisher"]
      end
    end

    context 'when PUBLISHER_TYPE="Publisher" in the UOIS xml' do
      it 'returns the name and type.' do
        Fixtures.use('patriots_day/image_1.xml').uois.publishers.name == ["Harvard Universiry Archives"]
        Fixtures.use('patriots_day/image_1.xml').uois.publishers.type == ["Copyright Holder"]
      end
    end

    context 'when PUBLISHER_TYPE="Distributor"' do
      it 'returns the name and type.' do
        Fixtures.use('patriots_day/video_1.xml').uois.publishers.name == ["WGBH Educational Foundation"]
        Fixtures.use('patriots_day/image_1.xml').uois.publishers.type == ["Distributor"]
      end
    end
  end

  ##
  # Coverage specifics
  #

  describe '#dates_portrayed' do
    it 'returns the date portrayed' do
      Fixtures.use('march_on_washington/audio_1.xml').uois.dates_portrayed.should == ["04/29/2011"]
    end
  end

  describe '#event_locations' do
    it 'returns the event location' do
      Fixtures.use('march_on_washington/audio_1.xml').uois.event_locations.should == ["Seattle (Wash.)"]
    end
  end

  describe '#to_pbcore' do

    before(:all) {

      Fixtures.cwd("#{fixture_path}/artesia")
      

      # test series
      @pbcore_series_1 = Fixtures.use('rock_and_roll/series_1.xml').uois.to_pbcore

      # test collections
      @pbcore_collection_1 = Fixtures.use('patriots_day/collection_1.xml').uois.to_pbcore

      # test programs
      @pbcore_program_1 = Fixtures.use('zoom/program_1.xml').uois.to_pbcore

      # test videos
      @pbcore_video_element_1 = Fixtures.use('rock_and_roll/video_element_1.xml').uois.to_pbcore
      @pbcore_video_clip_1 = Fixtures.use('zoom/video_clip_1.xml').uois.to_pbcore

      # test audio
      @pbcore_audio_item_1 = Fixtures.use('march_on_washington/audio_1.xml').uois.to_pbcore

      # test images
      @pbcore_image_1 = Fixtures.use('patriots_day/image_1.xml').uois.to_pbcore
      @pbcore_image_2 = Fixtures.use('patriots_day/image_3.xml').uois.to_pbcore
    }

    it 'sets value for HydraPbcore::Datasteam::Document#series' do
      @pbcore_series_1.series.should == ["Rock and Roll"]
      @pbcore_program_1.series.should == ["ZOOM, Series II"]
      @pbcore_video_element_1.series.should == ["Rock and Roll"]
      @pbcore_audio_item_1.series.should == ["March on Washington"]
      @pbcore_image_2.series.should == ["Perspectives"]
    end

    it 'sets value for HydraPbcore::Datasteam::Document#program' do
      @pbcore_program_1.program.should == ["Best of the 70's"]
      @pbcore_video_element_1.program.should == ["Respect"]
      @pbcore_audio_item_1.program.should == ["Revisiting the March on Washington"]
      @pbcore_image_2.program.should == ["Negro and The American Promise, The"]
    end

    
    pending 'sets the value for HydraPbcore::Datastream::Document#element'
    pending 'sets the value for HydraPbcore::Datastream::Document#segment'
    pending 'sets the value for HydraPbcore::Datastream::Document#clip'
    pending 'sets the value for HydraPbcore::Datastream::Document#segment'
    pending 'sets the value for HydraPbcore::Datastream::Document#item'
    pending 'sets the value for HydraPbcore::Datastream::Document#category'
    

    it 'sets value for HydraPbcore::Datastream::Document#title according to what the UOIS xml is representing (e.g. Series, Program, Collection, etc).' do
      # For some reason, direct comaprisons fail here, e.g. @pbcore_series_1.title.should == @pbcore_series_1.series
      # Converting them to arrays works though, and that's good enough for this test.
      @pbcore_series_1.title.to_ary.should == @pbcore_series_1.series.to_ary
      @pbcore_program_1.title.to_ary.should == @pbcore_program_1.program.to_ary
      @pbcore_collection_1.title.to_ary.should == @pbcore_collection_1.collection.to_ary
      @pbcore_video_element_1.title.to_ary.should == @pbcore_video_element_1.element.to_ary
      @pbcore_audio_item_1.title.to_ary.should == @pbcore_audio_item_1.item.to_ary
      @pbcore_image_1.title.to_ary.should == @pbcore_image_1.image.to_ary
    end

    it 'sets pbcore description and type for a "Series"' do
      @pbcore_series_1.description.type.should == ["Series"]
      # NOTE: The output here is will automatically unescape xhtml entities.
      @pbcore_series_1.description.should == ["This ten-part series, explores the musical styles, influences, and complex creative processes that have allowed rock to endure, from its renegade beginnings in the 1950s to the 1990s. From performers to producers, songwriters to studio engineers, session musicians to disk jockeys, Rock & Roll is an extensively researched and revealing history built on stories from and about the innovators who defined the music that has rocked the nation and the world for 40 years. A co-production between WGBH/Boston and BBC, this collection contains interviews created for the series."]
    end

    it 'sets pbcore description and type for a "Program"' do  
      @pbcore_program_1.description.type.should == ["Program"]
      @pbcore_program_1.description.should == ["Re-live what it was like to be a ZOOMer in the 1970's, with this retrospective collection of games and music numbers from the Emmy award-winning Children's series."]
    end

    it 'sets pbcore description and type for  a "Collection"' do  
      @pbcore_collection_1.description.type.should == ["Collection"]
      # NOTE: The output here is will automatically unescape xhtml entities.
      @pbcore_collection_1.description.should == ['"From the Vault" is an ongoing collaboration with WGBH Radio (89.7) and WGBH.org, bringing treasures from the archives to new audiences.This curated collection gives a sense of the range of the WGBH archives, highlighting rare or seldom-seen materials.']
    end

    it 'sets pbcore description and type for a "Clip"' do  
      @pbcore_video_clip_1.description.type.should == ["Clip"]
      @pbcore_video_clip_1.description.should == ["Re-live your favorite ZOOM memories! In this short clip, ZOOM kid Bernadette shows viewers how to perform her complex arm-swinging routine."]
    end

    it 'sets pbcore description and type for an "Element"' do
      @pbcore_video_element_1.description.type.should == ["Element"]
      @pbcore_video_element_1.description.should == ["Interview with Rufus Thomas [Part 2 of 4]"]
    end

    it 'sets value for HydraPbcore::Datasteam::Document#description.type for an "Item"' do
      @pbcore_audio_item_1.description.type.should == ["Item"]
      @pbcore_audio_item_1.description.should == ["Al Hulsen reported from around Washington D.C. on the day of the March, and shares the personal significance of this landmark event. Mr. Hulsen was a producer and journalist from WGBH-FM in Boston in 1963. He was interviewed at Puget Sound Public Radio, KUOW 94.9 FM, in Seattle, Washington on April 29, 2011."]
    end

  end
end