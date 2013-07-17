require "spec_helper"

describe CustomCollectionsController do
  describe "routing" do

    it "routes to #index" do
      get("/custom_collections").should route_to("custom_collections#index")
    end

    it "routes to #new" do
      get("/custom_collections/new").should route_to("custom_collections#new")
    end

    it "routes to #show" do
      get("/custom_collections/1").should route_to("custom_collections#show", :id => "1")
    end

    it "routes to #edit" do
      get("/custom_collections/1/edit").should route_to("custom_collections#edit", :id => "1")
    end

    it "routes to #create" do
      post("/custom_collections").should route_to("custom_collections#create")
    end

    it "routes to #update" do
      put("/custom_collections/1").should route_to("custom_collections#update", :id => "1")
    end

    it "routes to #destroy" do
      delete("/custom_collections/1").should route_to("custom_collections#destroy", :id => "1")
    end

  end
end
