require 'spec_helper'

describe Artesia::Datastream::TeamsAssetFile do  

  subject(:teams_asset_file) { Artesia::Datastream::TeamsAssetFile.new }

  describe '#set_xml' do
    let!(:valid_xml) { File.read("#{fixture_path}/teams_asset_files/zoom.xml") }

    it "applies valid xml to the OM terminology" do
      teams_asset_file.set_xml valid_xml
      teams_asset_file.assets.count.should == 1
      teams_asset_file.assets.asset.count.should == 6
      teams_asset_file.assets.asset.metadata.count.should == 6
      teams_asset_file.assets.asset.content.count.should == 6
    end

  end
end