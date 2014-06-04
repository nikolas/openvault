#TODO before each, create two items and put them in solr
require 'spec_helper'
require 'openvault'
require 'openvault/pbcore'
require "#{RSpec.configuration.fixture_path}/pbcore/load_fixtures"

describe SeriesController do

  before :all do
    @series = create(:series)
  end

  after :all do
    @series.delete
  end
  

  describe "GET show" do

    it "assigns a solr document to @document" do
      get :show, {id: @series.id}
      assigns(:document).should_not be_nil
    end

    it "assigns a Series record to @series" do
      get :show, {id: @series.id}
      assigns(:series).should be_a Series
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
      get :print, {id: @series.id}
      assigns(:document).should_not be_nil
    end
  end
end
