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

  scenario "metadata includes date" do
    visit "/"
    fill_in 'q', with: @program.title
    click_button 'search'    
    save_and_open_page
    expect(page).to have_content("Date:#{@program.pbcore.asset_date.first}")
  end
end
