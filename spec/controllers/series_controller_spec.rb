#TODO before each, create two items and put them in solr
require 'spec_helper'
require 'openvault'
require 'openvault/pbcore'
require "#{RSpec.configuration.fixture_path}/pbcore/load_fixtures"

describe SeriesController do
  before :all do
    ActiveFedora::Base.all.each do |ab|
      ab.delete
    end
    Fixtures.cwd("#{fixture_path}/pbcore")
    a = Openvault::Pbcore::DescriptionDocumentWrapper.new(Fixtures.use("artesia/rock_and_roll/series_1.xml")).model
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
      assigns(:videos).should_not be_nil
      assigns(:programs).should_not be_nil 
    end
    
    it "@rel is not nil" do
      get :show, {id: @id}
      assigns(:rel).should_not be_nil
    end
  end

  describe "GET browse" do
    it 'renders browse_by_title' do
      get :browse_by_title
      expect(response).to render_template :browse_by_title
    end
  end
  
  describe "GET print" do
    it "returns a valid solr document" do
      get :print, {id: @id}
      assigns(:document).should_not be_nil
    end
  end
  
end