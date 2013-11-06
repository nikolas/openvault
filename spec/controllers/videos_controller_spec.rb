#TODO before each, create two items and put them in solr
require 'spec_helper'
require 'openvault'
require 'openvault/pbcore'
require "#{RSpec.configuration.fixture_path}/pbcore/load_fixtures"

describe VideosController do
  before :all do
    ActiveFedora::Base.all.each do |ab|
      ab.delete
    end
    Fixtures.cwd("#{fixture_path}/pbcore")
    a = Openvault::Pbcore.get_model_for(Fixtures.use("artesia/rock_and_roll/video_1.xml"))
    a.save!
    a.create_relations_from_pbcore!
    @id = a.pid
  end
  describe "GET show" do
    it "returns a valid solr document" do
      get :show, {id: @id}
      assigns(:document).should_not be_nil 
    end
    
    it "@images, @videos, @programs are not nil" do
      get :show, {id: @id}
      assigns(:images).should_not be_nil
      assigns(:program).should_not be_nil
      assigns(:transcripts).should_not be_nil 
    end
    
    it "@rel is not nil" do
      get :show, {id: @id}
      assigns(:rel).should_not be_nil
    end
  end
  
  describe "GET print" do
    it "returns a valid solr document" do
      get :print, {id: @id}
      assigns(:document).should_not be_nil
    end
  end
  
end