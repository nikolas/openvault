require 'spec_helper'
require "#{RSpec.configuration.fixture_path}/pbcore/load_fixtures"

describe PbcoreAccessors do

  class TestObject 
    include PbcoreAccessors
    attr_accessor :pbcore

    def initialize 
      Fixtures.cwd "#{RSpec.configuration.fixture_path}/pbcore"
      @pbcore = Fixtures.use("artesia/patriots_day/video_1.xml")
    end
  end

  before :all do
    @obj = TestObject.new
  end
  
  describe "original_file_name" do
    it "returns original file name from pbcore metadata" do
      expect(@obj.original_file_name).to eq "barcode24136.mov"
    end
  end
end
