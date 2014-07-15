require 'spec_helper'
require "#{RSpec.configuration.fixture_path}/pbcore/load_fixtures"
require 'openvault/pbcore'

feature "User views search results" do
  before(:all) do 
    Fixtures.cwd("#{fixture_path}/pbcore")
    @program = Program.new
    @program.pbcore.ng_xml = Fixtures.raw("artesia/patriots_day/program_1.xml")
    @program.save!
  end

  scenario "metadata includes title" do 
    visit "/"
    fill_in 'q', with: @program.title
    click_button 'search'
    expect(page).to have_content("#{@program.title}")
  end

  scenario "metadata includes media type" do
    visit "/"
    fill_in 'q', with: @program.title
    click_button 'search'
    expect(page).to have_content("Media Type:#{@program.to_solr['active_fedora_model_ssi']}")
  end

  scenario "metadata includes date" do
    visit "/"
    fill_in 'q', with: @program.title
    click_button 'search'    
    expect(page).to have_content("Date:#{@program.asset_date}")
  end
end
