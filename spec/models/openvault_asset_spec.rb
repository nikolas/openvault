require 'spec_helper'

describe OpenvaultAsset do

  let(:valid_xml) { File.read("#{fixture_path}/artesia_ingest/zoom/uois_program.xml") }
  let(:depositor) { "openvault_testing@wgbh.org" }

  subject (:ov_asset) { OpenvaultAsset.new }

  it "saves a datastream for UOIS xml" do
    ov_asset.uois.set_xml valid_xml
    ov_asset.apply_depositor_metadata depositor
    ov_asset.save!
    compare = ActiveFedora::Base.find ov_asset.pid, :cast => true
    compare.uois.to_xml.should == ov_asset.uois.to_xml
  end

  it 'saves belongs_to relationship when unsaved OpenvaultAsset models are added to saved ArtesiaIngest' do
    ov_asset.apply_depositor_metadata depositor
    artesia_ingest = ArtesiaIngest.create!
    artesia_ingest.openvault_assets << ov_asset
    check = ActiveFedora::Base.find ov_asset.pid, :cast => true
    check.artesia_ingest.should == artesia_ingest
  end

  it 'saves belongs_to relationship when saved ArtesiaIngest is added to OpenvaultAsset via #artesia_ingest, and OpenvaultAsset is saved' do
    artesia_ingest = ArtesiaIngest.create!
    ov_asset.apply_depositor_metadata depositor
    ov_asset.artesia_ingest = artesia_ingest
    ov_asset.save!
    check = OpenvaultAsset.find(ov_asset.pid)
    check.artesia_ingest.should == artesia_ingest
  end

end