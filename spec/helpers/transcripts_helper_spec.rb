require 'spec_helper'
require "#{RSpec.configuration.fixture_path}/pbcore/load_fixtures"
require 'openvault/pbcore'
include TranscriptsHelper

describe "render_transcript" do

  describe "for transcripts" do
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

    it "changes smil to proper html markup" do
      transformation = render_transcript(@transcript.tei)
      expect(transformation).not_to include ("smil:begin")
      expect(transformation).to include("data-timecodebegin")
    end
  end

  describe "for logs" do
    it "doesn't display the : without a speaker" do
      @transcript = Transcript.new
      @transcript.tei.ng_xml = Fixtures.raw("../tei/Joyce_Chen_log_without_speaker.xml")
      transformation = render_transcript(@transcript.tei)
      expect(transformation).not_to include ("<strong class=\"speaker q\">:")
    end

    it "does display the : with a speaker" do
      @transcript = Transcript.new
      @transcript.tei.ng_xml = Fixtures.raw("../tei/Joyce_Chen_log_with_speaker.xml")
      transformation = render_transcript(@transcript.tei)
      expect(transformation).to include("<strong class=\"speaker q\">EXTENDED DESCRIPTION:")
    end
  end
end
