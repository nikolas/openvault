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
    it 'returns an empty string when the Video has no pbcore xml' do
      expect(video.original_file_name).to eq ''
    end
  end

  let(:video) { Video.new }

  describe '#thumbnail_url' do
    context 'has image directly related to it' do
      it "returns url of first image" do
        allow(video).to receive(:images) do
          [double(image_url: "video_image.gif")]
        end
        expect(video.thumbnail_url).to eq "video_image.gif"
      end
    end

    context "has no associated images" do
      it "returns nil" do
        allow(video).to receive(:images) { [] }
        expect(video.thumbnail_url).to eq nil
      end
    end
  end
end
