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
  
end
