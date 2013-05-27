require 'spec_helper'

describe ArtesiaIngest do

  let!(:valid_file) { File.open("#{fixture_path}/ingest/artesia.xml") }
  let!(:invalid_file) { File.open("#{fixture_path}/ingest/malformed.xml") }

  subject(:ingest) { ArtesiaIngest.new }

  it "saves a datastream for source xml" do
    xml = valid_file.read
    ingest.teams_asset_file.ng_xml = Nokogiri::XML(xml)
    ingest.save!
    compare = Datastream::TeamsAssetFile.new
    compare.ng_xml = Nokogiri::XML(xml)
    ingest.teams_asset_file.to_xml.should == compare.to_xml
  end
end