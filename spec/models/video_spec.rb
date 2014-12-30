require 'spec_helper'
require "#{RSpec.configuration.fixture_path}/pbcore/load_fixtures"

describe Video do

  before(:each) { Fixtures.cwd("#{fixture_path}/pbcore") }

  subject(:video) { Video.new }
  subject(:image) { Image.new }

  describe '#title' do
    it 'returns the correct title from a pbcore datastream' do

      video.pbcore.ng_xml = Fixtures.use('artesia/rock_and_roll/video_1.xml').ng_xml
      video.title.should == "Interview with Rufus Thomas [Part 2 of 4]"

      video.pbcore.ng_xml = Fixtures.use('artesia/rock_and_roll/video_2.xml').ng_xml
      video.title.should == "Interview with Dick Dale [Part 1 of 2]"

      video.pbcore.ng_xml = Fixtures.use('artesia/rock_and_roll/video_3.xml').ng_xml
      video.title.should == "Interview with Sam Phillips [Part 6 of 6]"

      video.pbcore.ng_xml = Fixtures.use('artesia/patriots_day/video_2.xml').ng_xml
      video.title.should == "Malcolm X Interview"

    end
  end

  describe '#original_file_name' do
    it 'returns nil when the Video has no pbcore xml' do
      expect(video.original_file_name).to eq nil
    end
  end

  describe '#thumbnail_url' do
    it 'returns the same url as the associated image' do
      video.pbcore.ng_xml = Fixtures.use('artesia/patriots_day/video_1.xml').ng_xml
      image.pbcore.ng_xml = Fixtures.use('artesia/patriots_day/image_2.xml').ng_xml
      video.images << image
      expect(video.images.first.image_url).to eq video.thumbnail_url
    end
  end
end
