#TODO before each, create two items and put them in solr
require 'spec_helper'
require 'openvault'
require 'openvault/pbcore'
require "#{RSpec.configuration.fixture_path}/pbcore/load_fixtures"

describe ProgramsController do
  before :all do
    ActiveFedora::Base.all.each do |ab|
      ab.delete
    end
    Fixtures.cwd("#{fixture_path}/pbcore")
    a = Openvault::Pbcore::DescriptionDocumentWrapper.new(Fixtures.use("artesia/rock_and_roll/program_1.xml")).new_model
    a.save!
    Openvault::Pbcore::AssetRelationshipBuilder.new(a).relate
    @id = a.pid
  end

  describe "GET show" do
    it "returns a valid solr document" do
      get :show, {id: @id}
      assigns(:document).should_not be nil
    end

    it "@images, @videos, @audios are not nil" do
      get :show, {id: @id}
      assigns(:program).all_images.should_not be nil
      assigns(:program).videos.should_not be nil
      assigns(:program).audios.should_not be nil
    end
  end

  describe "GET print" do
    it "returns a valid solr document" do
      get :print, {id: @id}
      assigns(:document).should_not be nil
    end
  end
  
end
