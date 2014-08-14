require 'spec_helper'
require "#{RSpec.configuration.fixture_path}/pbcore/load_fixtures"
require 'openvault/pbcore'

feature "User visits catalog#show" do
  before(:all) do 
    Fixtures.cwd("#{fixture_path}/pbcore")
    @video = Video.new
    @video.pbcore.ng_xml = Fixtures.raw("artesia/patriots_day/video_1.xml")
    @video.save!
  end

  scenario "metadata includes date" do
    visit "/catalog/#{@video.pid}"
    expect(page).to have_content("#{@video.date_portrayed}")
  end
  
  scenario "non-existent returns 404" do
    visit "/catalog/nope:12345"
    expect(page.status_code).to eq(404)
    expect(page).to have_content("The page you were looking for doesn't exist.")
  end
end
