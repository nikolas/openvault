require 'spec_helper'

describe CustomCollectionItem do
  
  before :each do
    @u = create(:user, role: 'scholar')
    @cc = create(:custom_collection, user_id: @u.id)
    @cci = create(:custom_collection_item, custom_collection_id: @cc.id)
  end
  
  it "should have be valid with all attributes" do
    @cci.should be_valid
  end
  
  it "should be invalid without a openvault_asset_pid" do
    build(:custom_collection_item, openvault_asset_pid: nil).should_not be_valid
  end
  
  it "should be invalid without a custom_collections_id" do
    build(:custom_collection_item, custom_collection_id: nil).should_not be_valid
  end
  
  it "should be ensure hash of annotations" do
    build(:custom_collection_item, annotations: 'testing fail').should be {'testing fail'}
  end
  
  it "should create a have a valid OpenvaultAsset" do
    ov = OpenvaultAsset.new
    ov.apply_depositor_metadata "openvault_testing@wgbh.org"
    ov.save
    item = create(:custom_collection_item, openvault_asset_pid: ov.pid)
    item.ov_asset.pid.should eq(ov.pid)
  end
  
end
