require 'spec_helper'
require 'openvault'
require "#{RSpec.configuration.fixture_path}/artesia/load_fixtures"
require "#{RSpec.configuration.fixture_path}/pbcore/load_fixtures"

describe OpenvaultAsset do

  subject(:ov_asset) { OpenvaultAsset.new }

  before(:each) { ov_asset.apply_depositor_metadata "openvault_testing@wgbh.org" }

  context 'with Artesia XML' do

    before(:each) { Fixtures.cwd "#{fixture_path}/artesia" }

    it "saves a datastream for UOIS xml" do
      ov_asset.uois.ng_xml = Fixtures.use("zoom/video_1.xml").ng_xml
      # ov_asset.apply_depositor_metadata depositor
      ov_asset.save!
      compare = OpenvaultAsset.find ov_asset.pid
      compare.uois.to_xml.should == ov_asset.uois.to_xml
    end

    it 'saves belongs_to relationship when unsaved OpenvaultAsset models are added to saved ArtesiaIngest' do
      # ov_asset.apply_depositor_metadata depositor
      artesia_ingest = ArtesiaIngest.create!
      artesia_ingest.openvault_assets << ov_asset
      check = OpenvaultAsset.find ov_asset.pid
      check.artesia_ingest.should == artesia_ingest
    end    
  end


  context 'with PBCore XML' do

    before(:each) { Fixtures.cwd "#{fixture_path}/pbcore" }

    it 'saves belongs_to relationship when saved ArtesiaIngest is added to OpenvaultAsset via #artesia_ingest, and OpenvaultAsset is saved' do
      artesia_ingest = ArtesiaIngest.create!
      # ov_asset.apply_depositor_metadata depositor
      ov_asset.artesia_ingest = artesia_ingest
      ov_asset.save!
      check = OpenvaultAsset.find(ov_asset.pid)
      check.artesia_ingest.should == artesia_ingest
    end

    it 'saves a datastream for PBCore xml' do
      ov_asset.pbcore.ng_xml = Fixtures.use('mars/program_1.xml').ng_xml
      ov_asset.save!
      compare = OpenvaultAsset.find ov_asset.pid
      compare.pbcore.to_xml.should == ov_asset.pbcore.to_xml
    end
  end

  describe 'identifying type of asset from metadata' do

    describe '#is_series?' do
      pending 'returns true if PBCore XML describes a series record' do
        Fixtures.use('mars/series_1.xml').is_series?.should == true
      end
    end

    describe '#is_program?' do
      pending 'returns true if PBCore XML describes a program record' do
        Fixtures.use('mars/program_1.xml').is_program?.should == true
      end
    end

    describe '#is_collection?' do
      pending 'returns true if PBCore XML describes a collection record' do
        Fixtures.use('mars/collection_1.xml').is_collection?.should == true
      end
    end

    describe '#is_video?' do
      pending 'returns true if PBCore XML describes a video record' do
        Fixtures.use('mars/video_1.xml').is_video?.should == true
      end
    end

    describe '#is_image?' do
      pending 'returns true if PBCore XML describes an image record' do
        Fixtures.use('mars/image_1.xml').is_image?.should == true
      end
    end

    describe '#is_transcript?' do
      pending 'returns true if PBCore XML describes a transcript record' do
        Fixtures.use('mars/transcript_1.xml').is_transcript?.should == true
      end
    end

    describe '#is_audio?' do
      pending 'returns true if PBCore XML describes an audio record' do
        Fixtures.use('mars/audio_1.xml').is_audio?.should == true
      end
    end

    describe '#is_item?' do
      pending 'returns true if PBCore XML describes an item record' do
        Fixtures.use('mars/item_1.xml').is_item?.should == true
      end
    end

    describe '#is_element?' do
      pending 'returns true if PBCore XML describes an element record' do
        Fixtures.use('mars/element_1.xml').is_element?.should == true
      end
    end

    describe '#is_clip?' do
      pending 'returns true if PBCore XML describes a clip record' do
        Fixtures.use('mars/clip_1.xml').is_clip?.should == true
      end
    end
  end


  describe '#use_best_title' do

    # TODO: Get rid of the .to_ary at the ends of the title accessors (e.g. #series.to_ary), once the fix
    # is published to rubygems.

    pending 'assumes the series title for series records' do
      Fixtures.use('mars/series_1.xml').use_best_title.should == Fixtures.use('mars/series_1.xml').series.to_ary
    end

    pending 'assumes the program title for program records' do
      Fixtures.use('mars/program_1.xml').use_best_title.should == Fixtures.use('mars/program_1.xml').program.to_ary
    end

    pending 'assumes the collection title for collection records' do
      Fixtures.use('mars/collection_1.xml').use_best_title.should == Fixtures.use('mars/collection_1.xml').collection
    end

    pending 'assumes the video title for video records' do
      Fixtures.use('mars/video_1.xml').use_best_title.should == Fixtures.use('mars/video_1.xml').video.to_ary
    end

    pending 'assumes the image title for image records' do
      Fixtures.use('mars/image_1.xml').use_best_title.should == Fixtures.use('mars/image_1.xml').image.to_ary
    end

    pending 'assumes the element title for element records' do
      Fixtures.use('mars/element_1.xml').use_best_title.should == Fixtures.use('mars/element_1.xml').element.to_ary
    end

    pending 'assumes the clip title for clip records' do
      Fixtures.use('mars/clip_1.xml').use_best_title.should == Fixtures.use('mars/clip_1.xml').clip.to_ary
    end

    pending 'assumes the item title for item records' do
      Fixtures.use('mars/item_1.xml').use_best_title.should == Fixtures.use('mars/item_1.xml').item.to_ary
    end

    pending 'assumes the audio title for audio records' do
      Fixtures.use('mars/audio_1.xml').use_best_title.should == Fixtures.use('mars/audio_1.xml').audio.to_ary
    end

    pending 'assumes the transcript title for transcript records' do
      Fixtures.use('mars/transcript_1.xml').use_best_title.should == Fixtures.use('mars/transcript_1.xml').transcript.to_ary
    end

  end
  
end