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
    @transcript.tei.ng_xml = Fixtures.raw("../tei/Patriots_Day_tei.xml")
    @video.transcripts << @transcript
    @video = OpenvaultAsset.find(@video.pid, cast: true)
  end
  
  def setup(type, fixture_path)
    asset = type.new
    asset.pbcore.ng_xml = Fixtures.raw(fixture_path)
    asset.save!
    return asset
  end
  
  def expects(asset)
    visit "/catalog/#{asset.pid}"
    expect(page).to have_content("#{asset.date_portrayed}")
  end
  
  
  scenario "series works" do
    series = setup(Series, "artesia/rock_and_roll/series_1.xml")
    expects(series)
  end
  
  scenario "program works" do
    program = setup(Program, "artesia/rock_and_roll/program_1.xml")
    expects(program) # no assets
    
    video = setup(Video, "artesia/patriots_day/video_1.xml")
    program.videos << video
    program.save!
    expects(program) # 1 asset
    
    audio = setup(Audio, "artesia/patriots_day/audio_1.xml")
    program.audios << audio
    program.save!
    expects(program) # multiple assets
  end
  
  scenario "video works" do
    video = setup(Video, "artesia/patriots_day/video_1.xml")
    expects(video)
  end
  
  scenario "audio works" do
    audio = setup(Audio, "artesia/patriots_day/audio_1.xml")
    expects(audio)
  end

  scenario "image works" do
    image = setup(Series, "artesia/rock_and_roll/image_1.xml")
    expects(image)
  end
  
  scenario "page displays transcript" do
    visit "/catalog/#{@video.pid}"
    expect(page).to have_content("TRANSCRIPT")
    expect(page).to have_content("Interviewer:")
  end

  scenario "non-existent returns 404" do
    visit "/catalog/nope:12345"
    expect(page.status_code).to eq(404)
  end

end
