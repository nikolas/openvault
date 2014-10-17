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

  let(:image) { Image.new }
 
  describe "#thumbnail_url" do
    it "returns url of this image" do
      allow(image).to receive(:image_url) { "image.gif" }
      expect(image.thumbnail_url).to eq "image.gif"
    end
  end  
end
