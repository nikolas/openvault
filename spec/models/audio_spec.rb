require 'spec_helper'
require "#{RSpec.configuration.fixture_path}/pbcore/load_fixtures"

describe Audio do

  before(:each) { Fixtures.cwd("#{fixture_path}/pbcore") }

  subject(:audio) { Audio.new }

  describe '#title' do
    it 'returns the correct title from a pbcore datastream' do
      audio.pbcore.ng_xml = Fixtures.use('artesia/march_on_washington/audio_1.xml').ng_xml
      audio.title.should == "Interview with Al Hulsen"

      audio.pbcore.ng_xml = Fixtures.use('artesia/patriots_day/audio_1.xml').ng_xml
      audio.title.should == "Bob Seay introduces the clip of Dr. Alfred Worcester"

      audio.pbcore.ng_xml = Fixtures.use('artesia/patriots_day/audio_2.xml').ng_xml
      audio.title.should == "Remembering James Brown at the Boston Garden, 1968"

      
    end
  end
  
end
