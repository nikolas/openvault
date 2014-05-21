require 'spec_helper'
require "#{RSpec.configuration.fixture_path}/pbcore/load_fixtures"

describe Video do

  before(:each) { Fixtures.cwd("#{fixture_path}/pbcore") }

  subject(:video) { Video.new }

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

end
