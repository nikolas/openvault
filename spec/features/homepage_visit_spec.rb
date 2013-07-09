require 'spec_helper'
describe "visiting homepage", :type => :feature do

  it "shows collections see all link" do
    visit '/'
    find('#collections').should have_link('See all >')
  end
  
end