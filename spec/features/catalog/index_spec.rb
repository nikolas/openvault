require 'spec_helper'
require "#{RSpec.configuration.fixture_path}/pbcore/load_fixtures"
require 'openvault/pbcore'

feature "User views search results" do
  before(:all) do 
    Fixtures.cwd("#{fixture_path}/pbcore")
    @audio = Audio.new
    @audio.pbcore.ng_xml = Fixtures.raw("artesia/patriots_day/audio_3.xml")
    @audio.save!
  end

  scenario "metadata includes title" do
    visit "/"
    fill_in 'q', with: @audio.title
    click_button 'search'
    expect(page).to have_content("#{@audio.title}")
  end

  scenario "metadata includes media type" do
    visit "/"
    fill_in 'q', with: @audio.title
    click_button 'search'
    expect(page).to have_content("Media Type:#{@audio.to_solr['active_fedora_model_ssi']}")
  end

  scenario "metadata includes date" do
    visit "/"
    fill_in 'q', with: @audio.title
    click_button 'search'    
    expect(page).to have_content("Date:#{@audio.asset_date}")
  end
end
