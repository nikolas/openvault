require 'spec_helper'

describe CustomCollectionItem do
  
  before :all do
    @u = create(:user, role: 'scholar')
    @cc = create(:custom_collection, owner: @u)
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


  describe "#title" do

    let(:custom_collection_item) { CustomCollectionItem.new }

    it 'returns the title that comes from the related Solr document' do
      test_title = 'foo'
      # stub the behavior of CustomCollectionItem#solr_doc
      allow(custom_collection_item).to receive(:solr_doc) { {'title_tesim' => test_title} }
      expect(custom_collection_item.title).to eq test_title
    end
  end

  context 'when fetching corresponding object from Fedora using #openvault_asset_pid' do
    
    let(:custom_collection_item) { CustomCollectionItem.new }

    describe '#fetch_ov_asset!' do
      it 'looks up corresponding Fedora object using #openvault_asset_id, and returns it if it exists' do
        custom_collection_item.openvault_asset_pid = OpenvaultAsset.create(pid: 'foo:123').pid
        expect(custom_collection_item.fetch_ov_asset!).to be_a OpenvaultAsset
      end

      it 'raises ActiveFedora::ObjectNotFoundError if lookup fails' do
        custom_collection_item.openvault_asset_pid = 'bogus:pid'
        expect{custom_collection_item.fetch_ov_asset!}.to raise_error ActiveFedora::ObjectNotFoundError
      end

    end

    describe '#fetch_ov_asset' do
      it 'returns nil instead of raising an error, when #openvault_asset_pid does not exist as a Fedora object pid' do
        custom_collection_item.openvault_asset_pid = 'bogus:pid'
        expect(custom_collection_item.fetch_ov_asset).to be nil
      end
    end

    describe '#ov_asset' do
      it 'lazy loads the corresponding Fedora object by calling #fetch_ov_asset once, and caching the result.' do
        ov_asset = OpenvaultAsset.new pid: 'foo:123'
        custom_collection_item.openvault_asset_pid = ov_asset.pid

        # stub this expensive thing
        allow(custom_collection_item).to receive(:fetch_ov_asset!) { ov_asset }

        # expect to only call the expensive thing once
        expect(custom_collection_item).to receive(:fetch_ov_asset!).once

        # because #ov_asset caches the result on the @ov_asset instance var.
        2.times { custom_collection_item.ov_asset }
      end
    end

  end
  
  
end
