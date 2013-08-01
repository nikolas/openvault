# encoding: UTF-8
require "spec_helper"

describe CatalogController do
  describe "routing" do
    
    it "routes to catalog#index" do
      get("/catalog?utf8=✓&q=asdf").should route_to("catalog#index")
    end
    
    it "routes to catalog#show" do
      get("/catalog/asdfasdf").should route_to("catalog#show", id: 'asdfasdf')
    end
    
  end
end