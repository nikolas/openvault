require 'spec_helper'

require "#{RSpec.configuration.fixture_path}/artesia/load_fixtures"

describe Artesia::Datastream::TeamsAssetFile do

  subject(:teams_asset_file) { Artesia::Datastream::TeamsAssetFile.new }

  before(:each) { Fixtures.cwd "#{fixture_path}/artesia"}

  describe '#ng_xml=' do

    it "applies valid xml to the OM terminology" do
      teams_asset_file.ng_xml = Fixtures.use("zoom/teams_asset_file.xml").ng_xml
      teams_asset_file.assets.count.should == 1
      teams_asset_file.assets.asset.count.should == 6
      teams_asset_file.assets.asset.metadata.count.should == 6
      teams_asset_file.assets.asset.content.count.should == 6
    end

  end
end