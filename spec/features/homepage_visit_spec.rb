require 'spec_helper'
require 'openvault'
require 'openvault/pbcore'
require "#{RSpec.configuration.fixture_path}/pbcore/load_fixtures"

describe "visiting homepage", :type => :feature do
  
  before :each do
    user = create(:user, :role => 'scholar')
    create(:custom_collection, :owner => user, :name => 'The Collection of Collections', :summary => 'asdfasdfasdf')
  end
  
  it "shows the carousel item" do
    FactoryGirl.create(:carousel_item, :title => 'The Collection of Collections', :body => 'asdfasdfasdf', enabled: true).save!
    visit '/'
    page.should have_css('.carousel-item', :count => 1)
  end
  
end
