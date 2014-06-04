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
end
