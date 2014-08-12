#TODO before each, create two items and put them in solr
require 'spec_helper'
require 'openvault'
require 'openvault/pbcore'
require "#{RSpec.configuration.fixture_path}/pbcore/load_fixtures"

describe SeriesController do

  describe "GET browse" do
    it 'renders browse_by_title' do
      get :browse_by_title
      expect(response).to render_template :browse_by_title
    end
  end

end
