require 'spec_helper'

describe Datastream::TeamsAssetFile do
  let!(:valid_file) { File.open("#{fixture_path}/ingest/artesia.xml") }

  subject(:teams_asset_file) { Datastream::TeamsAssetFile.new }

  # TODO: Consider replacing XML fixtures with an XML factory, if you can find one.
  it "should accept valid UOIS xml and stick it were it needs to go" do
    teams_asset_file.ng_xml = Nokogiri::XML(valid_file)
    teams_asset_file.assets.count.should == 1
    teams_asset_file.assets.asset.count.should == 6
    teams_asset_file.assets.asset.metadata.count.should == 6
    teams_asset_file.assets.asset.content.count.should == 6
  end

end