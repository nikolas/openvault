require 'spec_helper'
require 'helpers/test_helper'
require 'openvault'
require 'openvault/pbcore'
require "#{RSpec.configuration.fixture_path}/pbcore/load_fixtures"

describe "visiting homepage", :type => :feature do
  
  before :each do
    user = create(:user, :role => 'scholar')
    create(:custom_collection, :owner => user, :name => 'The Collection of Collections', :summary => 'asdfasdfasdf')
  end
  
  it "shows 3 blog posts" do
    visit '/'
    page.should have_css("div#blog .post", :count => 3)
    page.should have_css("div#blog #featured-post", :count => 1)
  end
  
  it "shows tweets" do
    visit '/'
    page.should have_css('div.tweet-item', :count => 5)
  end
  
  it "shows the carousel item" do
    FactoryGirl.create(:carousel_item, :title => 'The Collection of Collections', :body => 'asdfasdfasdf', enabled: true).save!
    visit '/'
    save_and_open_page
    page.should have_css('.carousel-item', :count => 1)
  end
  
  it "gets the most recent video assets for scroller"

end
