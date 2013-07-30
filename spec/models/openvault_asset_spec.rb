require 'spec_helper'

describe OpenvaultAsset do

  subject(:ov_asset) {
    ov = OpenvaultAsset.new
    ov.apply_depositor_metadata "openvault_testing@wgbh.org"
    ov
  }

  before(:all) do
    ng = Nokogiri::XML(File.read("#{fixture_path}/teams_asset_files/zoom.xml"))
    @uois_xml = ng.xpath('//UOIS[@UOI_ID="e3616b02f7257101d85c4a0b8e5e7f119ca0556a"]').to_xml
  end

  it "saves a datastream for UOIS xml" do
    ov_asset.uois.set_xml @uois_xml
    # ov_asset.apply_depositor_metadata depositor
    ov_asset.save!
    compare = OpenvaultAsset.find ov_asset.pid
    compare.uois.to_xml.should == ov_asset.uois.to_xml
  end

  it 'saves belongs_to relationship when unsaved OpenvaultAsset models are added to saved ArtesiaIngest' do
    # ov_asset.apply_depositor_metadata depositor
    artesia_ingest = ArtesiaIngest.create!
    artesia_ingest.openvault_assets << ov_asset
    check = OpenvaultAsset.find ov_asset.pid
    check.artesia_ingest.should == artesia_ingest
  end

  it 'saves belongs_to relationship when saved ArtesiaIngest is added to OpenvaultAsset via #artesia_ingest, and OpenvaultAsset is saved' do
    artesia_ingest = ArtesiaIngest.create!
    # ov_asset.apply_depositor_metadata depositor
    ov_asset.artesia_ingest = artesia_ingest
    ov_asset.save!
    check = OpenvaultAsset.find(ov_asset.pid)
    check.artesia_ingest.should == artesia_ingest
  end

end