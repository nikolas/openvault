require 'spec_helper'

describe CustomCollectionItem do
  
  before :all do
    @u = create(:user, role: 'scholar')
    @cc = create(:custom_collection, user_id: @u.id)
    @v = Video.new
    @v.save
    @p = Program.new
    @p.save
    @s = Series.new
    @s.save
    @a = Audio.new
    @a.save
    create(:custom_collection_item, openvault_asset_pid: @v.pid, kind: 'Video', custom_collection_id: @cc.id)
    create(:custom_collection_item, openvault_asset_pid: @a.pid, kind: 'Audio', custom_collection_id: @cc.id)
    create(:custom_collection_item, openvault_asset_pid: @p.pid, kind: 'Program', custom_collection_id: @cc.id)
    create(:custom_collection_item, openvault_asset_pid: @s.pid, kind: 'Series', custom_collection_id: @cc.id)
    @cci = create(:custom_collection_item, custom_collection_id: @cc.id, kind: 'Video')
  end
  
  it "should have be valid with all attributes" do
    @cci.should be_valid
  end
  
  it "returns only videos for scope videos" do
    @cc.custom_collection_items.videos.each do |v|
      v.kind.should eq('Video')
    end
  end
  
  it "returns only videos for scope audios" do
    @cc.custom_collection_items.audios.each do |v|
      v.kind.should eq('Audio')
    end
  end
  
  it "returns only videos for scope programs" do
    @cc.custom_collection_items.programs.each do |v|
      v.kind.should eq('Program')
    end
  end
  
  it "returns only videos for scope Series" do
    @cc.custom_collection_items.series.each do |v|
      v.kind.should eq('Series')
    end
  end
  
  it "should be invalid without a openvault_asset_pid" do
    build(:custom_collection_item, openvault_asset_pid: nil).should_not be_valid
  end
  
  it "should be invalid without a kind" do
    build(:custom_collection_item, kind: nil).should_not be_valid
  end
  
  it "should be invalid without a custom_collections_id" do
    build(:custom_collection_item, custom_collection_id: nil).should_not be_valid
  end
  
  it "should ensure hash of annotations" do
    build(:custom_collection_item, annotations: 'testing fail').should be {'testing fail'}
  end
  
  it "should create a have a valid OpenvaultAsset" do
    ov = Video.new
    ov.save
    item = create(:custom_collection_item, openvault_asset_pid: ov.pid)
    item.openvault_asset_pid.should eq(ov.pid)
  end
  
end
