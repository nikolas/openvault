require 'spec_helper'

describe OpenvaultAsset do

  let(:valid_xml) { File.read("#{fixture_path}/artesia_ingest/uois.zoom_sample.xml") }

  subject (:ov_asset) { OpenvaultAsset.new }

  it "saves a datastream for UOIS xml" do
    ov_asset.uois.set_xml valid_xml
    ov_asset.apply_depositor_metadata "openvault_testing@wgbh.org"
    ov_asset.save!
    compare = ActiveFedora::Base.find ov_asset.pid, :cast => true
    compare.uois.to_xml.should == ov_asset.uois.to_xml
  end
end