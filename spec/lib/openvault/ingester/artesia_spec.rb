require 'spec_helper'
require 'openvault/ingester/artesia'

require "#{RSpec.configuration.fixture_path}/artesia/load_fixtures"

describe Openvault::Ingester::Artesia do

  let(:depositor) { 'openvault_test@wgbh.org' }

  before(:each) { Fixtures.cwd "#{fixture_path}/artesia"}

  describe '#ingest!' do
    it "ingests without error when given valid xml and depositor" do
      expect{Openvault::Ingester::Artesia.ingest!(Fixtures.raw('zoom/teams_asset_file.xml'), depositor)}.to_not raise_error
    end
  end
    
end