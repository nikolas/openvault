require 'spec_helper'
require 'openvault'
require "#{RSpec.configuration.fixture_path}/artesia/load_fixtures"
require "#{RSpec.configuration.fixture_path}/pbcore/load_fixtures"

describe OpenvaultAsset do

  subject(:ov_asset) { OpenvaultAsset.new }

  before(:each) { ov_asset.apply_depositor_metadata "openvault_testing@wgbh.org" }

  context 'with Artesia XML' do

    before(:each) { Fixtures.cwd "#{fixture_path}/artesia" }

    it "saves a datastream for UOIS xml" do
      debugger
      ov_asset.uois.ng_xml = Fixtures.use("zoom/video_1.xml").ng_xml
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
  end


  context 'with PBCore XML' do

    before(:each) { Fixtures.cwd "#{fixture_path}/pbcore" }

    it 'saves belongs_to relationship when saved ArtesiaIngest is added to OpenvaultAsset via #artesia_ingest, and OpenvaultAsset is saved' do
      artesia_ingest = ArtesiaIngest.create!
      # ov_asset.apply_depositor_metadata depositor
      ov_asset.artesia_ingest = artesia_ingest
      ov_asset.save!
      check = OpenvaultAsset.find(ov_asset.pid)
      check.artesia_ingest.should == artesia_ingest
    end

    it 'saves a datastream for PBCore xml' do
      debugger
      ov_asset.pbcore.ng_xml = Fixtures.use('mars/program_1.xml').ng_xml
      ov_asset.save!
      compare = OpenvaultAsset.find ov_asset.pid
      compare.pbcore.to_xml.should == ov_asset.pbcore.to_xml
    end
  end
  
end