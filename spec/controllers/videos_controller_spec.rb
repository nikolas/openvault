#TODO before each, create two items and put them in solr
require 'spec_helper'
require 'openvault'
require 'openvault/pbcore'
require "#{RSpec.configuration.fixture_path}/pbcore/load_fixtures"

Fixtures.cwd File.expand_path('../fixtures/pbcore/', __FILE__)

describe VideosController do
  before :all do
    Fixtures.cwd("#{fixture_path}/pbcore")
    a = Openvault::Pbcore::DescriptionDocumentWrapper.new(Fixtures.use("artesia/rock_and_roll/video_1.xml")).new_model
    ActiveFedora::Base.all.each do |ab|
      ab.delete
    end
    a.save!
    Openvault::Pbcore::AssetRelationshipBuilder.new(a).relate
    @id = a.pid
  end

  describe "GET show" do
    it "returns a valid solr document" do
      get :show, {id: @id}
      assigns(:document).should_not be_nil
    end

    it "@images, @videos, @programs are not nil", broken: true do
      get :show, {id: @id}
      assigns(:images).should_not be_nil
      assigns(:program).should_not be_nil
      assigns(:transcripts).should_not be_nil
    end
  end

  describe "GET print" do
    it "returns a valid solr document" do
      get :print, {id: @id}
      assigns(:document).should_not be_nil
    end
  end
  
end
