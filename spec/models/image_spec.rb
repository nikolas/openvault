require 'spec_helper'
require "#{RSpec.configuration.fixture_path}/pbcore/load_fixtures"

describe Image do

  before(:each) { Fixtures.cwd("#{fixture_path}/pbcore") }

  subject(:image) { Image.new }

  describe '#title' do
    it 'returns the correct title from a pbcore datastream' do

      # this fixture has a specific image title
      image.pbcore.ng_xml = Fixtures.use('artesia/patriots_day/image_2.xml').ng_xml
      image.title.should == "The First Blow for Liberty. Battle of Lexington"

      # this fixture does not have a specific image title
      image.pbcore.ng_xml = Fixtures.use('artesia/rock_and_roll/image_1.xml').ng_xml
      image.title.should == "image"
    end
  end

  describe '#original_file_name' do
    it 'returns value of origial file name from the pbcore datastream' do
      image.pbcore.ng_xml = Fixtures.use('artesia/rock_and_roll/image_1.xml').ng_xml
      image.original_file_name.should == "barcode10847_thumbnail.jpg"
    end
  end
  
  describe '#to_solr' do
    it 'looks for related videos' do
      image.pbcore.ng_xml = Fixtures.use('artesia/rock_and_roll/image_1.xml').ng_xml
      expect(image.to_solr['has_related_video_bsi']).to eq(false)
    end
  end

  describe '#has_related_video?' do
    it 'returns true when the Image has a related Video' do
      allow(image).to receive(:video) { Video.new }
      expect(image.has_related_video?).to eq true
    end

    it 'returns false when the Image does not have a related Video' do
      allow(image).to receive(:video) { nil }
      expect(image.has_related_video?).to eq false
    end
  end
  
end
