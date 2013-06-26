require 'spec_helper'

describe ArtesiaIngest do

  subject(:artesia_ingest) { ArtesiaIngest.new }

  # valid_xml is an export from Artesia.
  let!(:valid_xml) { File.read("#{fixture_path}/artesia_ingest/teams_asset_file.zoom_sample.xml") }

  # valid_xml contains 6 <UOIS> nodes, each of which generate an OpenvaultAsset
  let(:ov_asset_count) { 6 }

  let(:invalid_xml) { 'this is not xml' }
  let(:depositor) { 'openvault_testing@wgbh.org' }

  it 'saves has_many relationships when unsaved OpenvaultAsset models are added to saved ArtesiaIngest' do
    ov1, ov2 = OpenvaultAsset.new, OpenvaultAsset.new
    ov1.apply_depositor_metadata depositor
    ov2.apply_depositor_metadata depositor
    artesia_ingest.save!
    artesia_ingest.openvault_assets << ov1 << ov2
    check1, check2 = OpenvaultAsset.find(ov1.pid), OpenvaultAsset.find(ov2.pid)
    artesia_ingest.openvault_assets[0].should == check1
    artesia_ingest.openvault_assets[1].should == check2
  end

  it 'saves has_many relationships when saved OpenvaultAsset models are added to unsaved ArtesiaIngest, and ArtesiaIngest is saved' do
    ov1, ov2 = OpenvaultAsset.new, OpenvaultAsset.new
    ov1.apply_depositor_metadata depositor
    ov2.apply_depositor_metadata depositor
    ov1.save!
    ov2.save!
    artesia_ingest.openvault_assets << ov1 << ov2
    artesia_ingest.save!
    check1, check2 = OpenvaultAsset.find(ov1.pid), OpenvaultAsset.find(ov2.pid)
    artesia_ingest.openvault_assets.should == [check1, check2]
  end

  it 'saves has_many relationships when saved ArtesiaIngest is added to OpenvaultAsset and OpenvaultAsset is saved' do
    ov1, ov2 = OpenvaultAsset.new, OpenvaultAsset.new
    ov1.apply_depositor_metadata depositor
    ov2.apply_depositor_metadata depositor
    artesia_ingest.save!
    ov1.artesia_ingest = artesia_ingest
    ov2.artesia_ingest = artesia_ingest
    ov1.save!
    ov2.save!
    check = ArtesiaIngest.find(artesia_ingest.pid)
    check.openvault_assets.should == [ov1, ov2]
  end




  describe '#apply_teams_asset_file' do

    context 'when given valid TEAMS_ASSET_FILE xml' do

      it 'sets the xml of the Datastream::TeamsAssetFile at ArtesiaIngest#teams_asset_file' do
        artesia_ingest.apply_teams_asset_file valid_xml
        artesia_ingest.teams_asset_file.to_xml.should_not be_nil
      end

      it "generates OpenvaultAsset models from xml in '#teams_asset_file' datastream" do
        artesia_ingest.apply_teams_asset_file valid_xml
        artesia_ingest.openvault_assets.count.should == 6
      end

      it 'does not generate duplicate OpenvaultAsset models when called more than once' do
        3.times { artesia_ingest.apply_teams_asset_file valid_xml }
        artesia_ingest.openvault_assets.count.should == ov_asset_count
      end

      pending 'relates OpenvaultAssets in ArtesiaIngest#openvault_assets with xml data from ArtesiaIngest#teams_asset_file' do
        artesia_ingest.apply_teams_asset_file valid_xml
        # TODO: check for specific relationship predicates.
        artesia_ingest.openvault_assets.each do |ov_asset|
          ov_asset.relationships.count.should > 0
        end
      end

    end

  end

  describe '#save_all!' do
    it 'saves 1 record for the ingest itself, and 1 record for each OpenvaultAsset in #openvault_assets' do
      count_before_ingest = ActiveFedora::Base.count
      artesia_ingest.apply_teams_asset_file valid_xml
      artesia_ingest.depositor = depositor
      artesia_ingest.save_all!
      ActiveFedora::Base.count.should == (count_before_ingest + ov_asset_count + 1)
    end

  end

  context 'when given invalid xml' do
    before(:each) do
      artesia_ingest.apply_teams_asset_file invalid_xml
    end

    pending "raises an error if xml is invalid"
    pending "should not insert a record for the ingest if if xml is invalid"
  end

  
end