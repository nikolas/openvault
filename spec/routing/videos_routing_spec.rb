# encoding: UTF-8
require "spec_helper"

describe VideosController do
  describe "routing" do

    it "routes to video#show when id only numbers" do
      get("/video/1234567890").should route_to("videos#show", id: "1234567890")
    end
    
  end
end