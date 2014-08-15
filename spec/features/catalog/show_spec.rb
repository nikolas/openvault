require 'spec_helper'
require "#{RSpec.configuration.fixture_path}/pbcore/load_fixtures"
require 'openvault/pbcore'

feature "User visits catalog#show" do

  before(:all) do 
    Fixtures.cwd("#{fixture_path}/pbcore")
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
    expects(program)
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
  
  # TODO: transcript
  
  scenario "non-existent returns 404" do
    visit "/catalog/nope:12345"
    expect(page.status_code).to eq(404)
    expect(page).to have_content("The page you were looking for doesn't exist.")
  end

end
