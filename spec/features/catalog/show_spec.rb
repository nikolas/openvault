require 'spec_helper'
require "#{RSpec.configuration.fixture_path}/pbcore/load_fixtures"
require 'openvault/pbcore'
include TranscriptsHelper
Capybara.asset_host = 'http://localhost:3000'

feature "User visits catalog#show" do
  before(:all) do 
    Fixtures.cwd("#{fixture_path}/pbcore")
    @video = Video.create
    @video.pbcore.ng_xml = Fixtures.raw("artesia/patriots_day/video_3.xml")
    @transcript = Transcript.new
    @transcript.pbcore.ng_xml = Fixtures.raw("artesia/patriots_day/transcript_1.xml")
    @transcript.tei.ng_xml = Fixtures.raw("artesia/patriots_day/transcript_tei_1.xml")
    @video.transcripts << @transcript
    @video = OpenvaultAsset.find(@video.pid, cast: true)
  end

  scenario "metadata includes date" do
    visit "/catalog/#{@video.pid}"
    expect(page).to have_content("#{@video.date_portrayed}")
  end
  
  scenario "page displays transcript" do
    visit "/catalog/#{@video.pid}"
    expect(page).to have_content("TRANSCRIPT")
    expect(page).to have_content("Interviewer:")
  end

  scenario "non-existent returns 404" do
    visit "/catalog/nope:12345"
    expect(page.status_code).to eq(404)
    expect(page).to have_content("The page you were looking for doesn't exist.")
  end
end
