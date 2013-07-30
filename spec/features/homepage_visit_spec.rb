require 'spec_helper'
require 'helpers/test_helper'
describe "visiting homepage", :type => :feature do

  it "shows collections see all link" do
    visit '/'
    find('#collections').should have_link('See all >')
  end
  
  # it "shows 6 blog posts" do
#     visit '/'
#     page.should have_css("div#blog .post", :count => 3)
#   end
end