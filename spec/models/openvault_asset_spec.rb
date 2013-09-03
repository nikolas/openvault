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
  
  describe "creating slugs" do
    
    before(:each) do
      # ActiveFedora::Base.reindex_everything
      file = File.open("#{fixture_path}/MARS_program.xml")
      ng = Nokogiri::XML(file)
      @ov2 = OpenvaultAsset.new
      @ov2.apply_depositor_metadata 'testing@test.com'
      @ov2.pbcore.ng_xml = ng
      @ov2.save!
      
      file2 = File.open("#{fixture_path}/MARS_program.xml")
      ng2 = Nokogiri::XML(file2)
      @ov22 = OpenvaultAsset.new
      @ov22.apply_depositor_metadata 'testing@test.com'
      @ov22.pbcore.ng_xml = ng2
      @ov22.save!
    end
    
    it "creates the proper slug" do
      #check = OpenvaultAsset.find(:slug => "#{@ov22.pbcore.series.first} #{@ov22.pbcore.title.first} #{@ov22.pbcore.episode.first} #{@ov22.noid}".parameterize)
      #@ov22.pid.should == check.first.pid
    end
    
    it "doesn't create duplicate slugs" do
      #check = OpenvaultAsset.find(:slug => "#{@ov22.pbcore.series.first} #{@ov22.pbcore.title.first} #{@ov22.pbcore.episode.first}".parameterize)
      #check.size.should eq(1)
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