require 'spec_helper'

describe CollectionsController do
  
  #create a valid Colleciton object
  def valid_attributes
    attributes_for(:collection)
  end
  
  describe "GET index" do
    it "assigns all collections as @collections" do
      collection = Collection.create! valid_attributes
      get :index, {}
      assigns(:collections).should eq([collection])
    end
  end

  describe "GET show" do
    it "assigns the requested collection as @collection" do
      collection = Collection.create! valid_attributes
      get :show, {:id => collection.to_param}
      assigns(:collection).should eq(collection)
    end
  end
  
end