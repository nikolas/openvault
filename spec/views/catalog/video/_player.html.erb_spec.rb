require 'spec_helper'
require "#{RSpec.configuration.fixture_path}/pbcore/load_fixtures"

describe 'catalog/video/_player.html.erb' do

  before :all do
    Fixtures.cwd("#{fixture_path}/pbcore")
    @ov_asset = create(:video, pbcore: Fixtures.use("artesia/rock_and_roll/video_1.xml"))
    @ov_asset
  end

  it 'has an mp4 source in the <video> element, with a URL ending in ".mp4"' do
    render partial: 'catalog/video/player'
    expect(rendered).to have_css('video source[type="video/mp4"][src$=".mp4"]')
  end

  it 'has a webm source in the <video> element, with a URL ending in ".webm"' do
    render partial: 'catalog/video/player'
    expect(rendered).to have_css('video source[type="video/webm"][src$=".webm"]')
  end


end