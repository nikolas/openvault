require 'spec_helper'

describe OpenvaultAsset do

  subject(:ov_asset) {
    ov = OpenvaultAsset.new
    ov.apply_depositor_metadata "openvault_testing@wgbh.org"
    ov
  }

  before(:all) do
    ng = Nokogiri::XML(File.read("#{fixture_path}/teams_asset_files/zoom.xml"))
    @uois_xml = ng.xpath('//UOIS[@UOI_ID="e3616b02f7257101d85c4a0b8e5e7f119ca0556a"]').to_xml
  end

  it "saves a datastream for UOIS xml" do
    ov_asset.uois.set_xml @uois_xml
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

  it 'saves belongs_to relationship when saved ArtesiaIngest is added to OpenvaultAsset via #artesia_ingest, and OpenvaultAsset is saved' do
    artesia_ingest = ArtesiaIngest.create!
    # ov_asset.apply_depositor_metadata depositor
    ov_asset.artesia_ingest = artesia_ingest
    ov_asset.save!
    check = OpenvaultAsset.find(ov_asset.pid)
    check.artesia_ingest.should == artesia_ingest
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
      check = OpenvaultAsset.find(:slug => "#{@ov22.pbcore.series.first} #{@ov22.pbcore.title.first} #{@ov22.pbcore.episode.first} #{@ov22.noid}".parameterize)
      @ov22.pid.should == check.first.pid
    end
    
    it "doesn't create duplicate slugs" do
      check = OpenvaultAsset.find(:slug => "#{@ov22.pbcore.series.first} #{@ov22.pbcore.title.first} #{@ov22.pbcore.episode.first}".parameterize)
      check.size.should eq(1)
    end
    
    
  end

end