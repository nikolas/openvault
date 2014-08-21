require 'spec_helper'
require "#{RSpec.configuration.fixture_path}/pbcore/load_fixtures"
require 'openvault/pbcore'
include TranscriptsHelper

describe "transforming tei xml to html" do
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

  it "changes smil to proper html markup" do
    transformation = transform_to_html(@transcript.tei.to_xml).to_s.html_safe
    expect(transformation).not_to include ("smil:begin")
    expect(transformation).to include("data-timecodebegin")
  end
end
