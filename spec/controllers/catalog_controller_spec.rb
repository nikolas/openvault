require 'spec_helper'

describe CatalogController do
  
  describe "GET index" do
    it "returns search results" do
      get :index
      assigns(:document_list).should_not be_nil
    end
    
  end
  
  describe "GET home" do
    it "get has the scroller items" do
      get :home
      assigns(:scroller_items).should_not be_nil
    end
    
    it "gets the collections" do
      get :home
      assigns(:custom_collections).should_not be_nil
    end
    
    it "gets the tweets" do
      get :home
      assigns(:tweets).should_not be_nil
    end
  end
  
end