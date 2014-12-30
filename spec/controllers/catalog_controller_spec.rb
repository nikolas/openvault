require 'spec_helper'
require 'openvault/pbcore'
require "#{RSpec.configuration.fixture_path}/pbcore/load_fixtures"

describe CatalogController do

  describe "GET index" do
    it "returns search results" do
      get :index
      expect_not_nil(:document_list)
    end

  end

  describe "GET home" do
    it "get has the scroller items" do
      get :home
      expect_not_nil(:scroller_items)
    end

    it "gets the collections" do
      get :home
      expect_not_nil(:custom_collections)
    end

    it "gets the tweets" do
      get :home
      expect_not_nil(:tweets)
    end
    
    it "gets blog posts" do
      get :home
      expect_not_nil(:feature)
      expect_not_nil(:posts)
      expect(assigns(:posts).length).to eq 3
    end
  end

  describe "GET Series stuff" do

    before :all do
      @series = create(:series)
    end

    after :all do
      @series.delete
    end


    describe "GET show" do

      it "assigns a solr document to @document" do
        get :show, {id: @series.id}
        expect_not_nil(:document)
      end

      it "assigns a Series record to @ov_asset" do
        get :show, {id: @series.id}
        assigns(:ov_asset).should be_a Series
      end

    end

    describe "GET print" do
      it "returns a valid solr document" do
        get :print, {id: @series.id}
        expect_not_nil(:document)
      end
    end
    
  end
  
  describe "GET Program stuff" do
    
    before :all do
      ActiveFedora::Base.all.each do |ab|
        ab.delete
      end
      Fixtures.cwd("#{fixture_path}/pbcore")
      a = Openvault::Pbcore::OpenvaultAssetUpdater.new(Fixtures.use("artesia/rock_and_roll/program_1.xml")).updated_openvault_asset
      a.save!
      Openvault::Pbcore::AssetRelationshipBuilder.new(a).establish_relationships_in_fedora
      @id = a.pid
    end
    
    describe "GET date range" do
      it "works same year" do
        get :index, {'range[broadcast_date_dtsim][begin]' => '2010', 'range[broadcast_date_dtsim][end]' => '2011'}
        expect(assigns(:document_list).count).to eq(1)
      end
      
      xit "excludes before" do
        get :index, {'range[broadcast_date_dtsim][begin]' => '2009', 'range[broadcast_date_dtsim][end]' => '2010'}
        expect(assigns(:document_list).count).to eq(0)
      end
      
      xit "excludes after" do
        get :index, {'range[broadcast_date_dtsim][begin]' => '2011', 'range[broadcast_date_dtsim][end]' => '2012'}
        expect(assigns(:document_list).count).to eq(0)
      end
    end

    describe "GET show" do
      it "returns a valid solr document" do
        get :show, {id: @id}
        expect_not_nil(:document)
      end
    end

    describe "GET print" do
      it "returns a valid solr document" do
        get :print, {id: @id}
        expect_not_nil(:document)
      end
    end

  end
  
  describe "GET Video stuff" do

    before :all do
      Fixtures.cwd("#{fixture_path}/pbcore")
      a = Openvault::Pbcore::OpenvaultAssetUpdater.new(Fixtures.use("artesia/rock_and_roll/video_1.xml")).updated_openvault_asset
      ActiveFedora::Base.all.each do |ab|
        ab.delete
      end
      a.save!
      Openvault::Pbcore::AssetRelationshipBuilder.new(a).establish_relationships_in_fedora
      @id = a.pid
    end

    describe "GET show xml" do
      it "returns a valid solr document" do
        get :show, {format: 'xml', id: @id}
        expect_not_nil(:document)
      end
    end
    
    describe "GET show" do
      it "returns a valid solr document" do
        get :show, {id: @id}
        expect_not_nil(:document)
      end
    end
    
    describe "GET print" do
      it "returns a valid solr document" do
        get :print, {id: @id}
        expect_not_nil(:document)
      end
    end

  end
  
  def expect_not_nil(obj)
    expect(assigns(obj)).to_not be nil
  end

end
