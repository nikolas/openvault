require 'spec_helper'

describe ArtesiaIngest do

  subject(:artesia_ingest) { ArtesiaIngest.new }

  # zoom_sample.xml is an export from Artesia, containing 6 interrelated assets.
  let!(:valid_xml) { File.read("#{fixture_path}/artesia_ingest/teams_asset_file.zoom_sample.xml") }
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

  

  describe '#save_all!' do
    it 'saves 1 record for the ingest itself, and 1 record for each child asset' do
      count_before_ingest = ActiveFedora::Base.count
      artesia_ingest.teams_asset_file.set_xml valid_xml
      artesia_ingest.depositor = depositor
      artesia_ingest.save_all!
      ActiveFedora::Base.count.should == (count_before_ingest + 7)
    end

    pending "raises an error if xml is invalid" do
      expect { artesia_ingest.set_teams_asset_file invalid_xml }.to raise_error
    end

    pending "should not insert a record for the ingest if if xml is invalid" do
      count_before_ingest = ActiveFedora::Base.count

      begin
        artesia_ingest.set_teams_asset_file invalid_xml
      rescue
        # Get around the error that is raised with invalid_xml
      end

      artesia_ingest.save_all!(depositor)

      # Count should be the same
      ActiveFedora::Base.count.should == count_before_ingest
    end
  end
end