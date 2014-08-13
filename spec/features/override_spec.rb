require 'spec_helper'
require 'openvault'

describe "visiting static page", :type => :feature do
  
  it "has right url and title" do
    visit '/catalog/advocates-advocates'
    # Redirected...
    expect(current_url).to include('/collections/advocates-advocates')
    expect(page).to have_css('h1', :text => 'The Advocates')
  end
  
end
