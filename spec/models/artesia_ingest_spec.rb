require 'spec_helper'

describe ArtesiaIngest do

  subject(:artesia_ingest) { ArtesiaIngest.new }

  # valid_xml is an export from Artesia.
  valid_xml = File.read("#{Fixtures.base_dir}/artesia/zoom/teams_asset_file.xml")
  # valid_xml contains 6 <UOIS> nodes, each of which generate an OpenvaultAsset
  ov_asset_count = 6
  invalid_xml = 'this is not xml'
  depositor = 'openvault_testing@wgbh.org'

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

  describe '#depositor=' do
    it 'sets depositor for all OpenvaultAssets' do
      artesia_ingest.apply_teams_asset_file valid_xml
      artesia_ingest.depositor = 'foo'
      artesia_ingest.openvault_assets.each do |ov_asset|
        ov_asset.depositor.should == 'foo'
      end
    end
  end

  # NOTE: #apply_teams_asset_file does other stuff using protected methods which are handled by other tests.
  describe '#apply_teams_asset_file' do
    it 'sets the xml of the Datastream::TeamsAssetFile at ArtesiaIngest#teams_asset_file' do
      artesia_ingest.apply_teams_asset_file valid_xml
      artesia_ingest.teams_asset_file.assets.to_xml.should_not be_nil
    end
  end


  # NOTE: testing protected methods requires you so call #send(:method_name) on the object.
  context 'protected methods called within #apply_teams_asset_file' do
    
    before(:each) do
      # NOTE: Normally you would want to just call #apply_teams_asset_file, which calls other protected methods,
      # but we want to isolate those methods here, so we explicitly set the xml for #teams_asset_file datastream.
      artesia_ingest.teams_asset_file.set_xml valid_xml
    end

    describe '#generate_openvault_assets (protected)' do
      
      it "generates OpenvaultAsset models from xml in '#teams_asset_file' datastream" do
        artesia_ingest.send(:generate_openvault_assets)
        artesia_ingest.openvault_assets.count.should == ov_asset_count
      end

      it 'does not generate duplicate OpenvaultAsset models when called more than once' do
        3.times { artesia_ingest.send(:generate_openvault_assets) }
        artesia_ingest.openvault_assets.count.should == ov_asset_count
      end

      it 'sets xml for #uois datastream for each of the OpenvaultAsset models in ArtesiaIngest#openvault_assets' do
        artesia_ingest.send(:generate_openvault_assets)
        artesia_ingest.openvault_assets.each do |ov_asset|
          ov_asset.uois.uoi_id.should_not be_nil
        end
      end

      it 'sets sets OpenvaultAsset#depositor from ArtesiaIngest#depositor for each in ArtesiaIngest#openvault_assets' do
        artesia_ingest.depositor = 'foo'
        artesia_ingest.send(:generate_openvault_assets)
        artesia_ingest.openvault_assets.each do |ov_asset|
          ov_asset.depositor.should == artesia_ingest.depositor
        end
      end

    end

    describe '#relate_openvault_assets (protected)' do

      it 'relates OpenvaultAssets in ArtesiaIngest#openvault_assets with xml data from ArtesiaIngest#teams_asset_file' do
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

  
end