require 'spec_helper'

describe "program and series lists", :type => :feature do

  # TODO: Re-implement after re-implementing 'Programs' button (see https://github.com/afred/openvault/issues/914)  
  # it "links to working programs list" do
  #   visit '/'
  #   click_link 'Programs'
  #   expect(page).to have_content('Browse Programs by Year')
  # end
  
  it "links to working series list" do
    visit '/'
    click_link 'Series'
    expect(page).to have_content('Browse Series by Title')
  end
  
end
