require 'spec_helper'

describe CatalogController do

  describe "GET index" do
    it "returns search results" do
      get :index
      expect(assigns(:document_list)).to_not be nil
    end

  end

  describe "GET home" do
    it "get has the scroller items" do
      get :home
      expect(assigns(:scroller_items)).to_not be nil
    end

    it "gets the collections" do
      get :home
      expect(assigns(:custom_collections)).to_not be nil
    end

    it "gets the tweets" do
      get :home
      expect(assigns(:tweets)).to_not be nil
    end
  end

  describe "GET series" do

    before :all do
      @series = create(:series)
    end

    after :all do
      @series.delete
    end


    describe "GET show" do

      it "assigns a solr document to @document" do
        get :show, {id: @series.id}
        assigns(:document).should_not be nil
      end

      it "assigns a Series record to @ov_asset" do
        get :show, {id: @series.id}
        assigns(:ov_asset).should be_a Series
      end

    end

    describe "GET print" do
      it "returns a valid solr document" do
        get :print, {id: @series.id}
        assigns(:document).should_not be nil
      end
    end
    
  end
  
end
