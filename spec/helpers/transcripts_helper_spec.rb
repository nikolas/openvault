require 'spec_helper'
require "#{RSpec.configuration.fixture_path}/pbcore/load_fixtures"
require 'openvault/pbcore'
include TranscriptsHelper

describe "render_transcript" do

  before(:all) do
    Fixtures.cwd("#{fixture_path}/pbcore")
  end
  
  describe "for transcripts" do
    it "changes smil to proper html markup" do
      @transcript = Transcript.new
      @transcript.tei.ng_xml = Fixtures.raw("../tei/Patriots_Day_tei.xml")
      transformation = render_transcript(@transcript.tei)
      expect(transformation).not_to include ("smil:begin")
      expect(transformation).to include("data-timecodebegin")
    end
    
    it "produces valid html even on empty transcripts" do
      @transcript = Transcript.new
      @transcript.tei.ng_xml = '<TEI xmlns="http://www.tei-c.org/ns/1.0" />'
      transformation = render_transcript(@transcript.tei)
      expect(transformation).to eq("<div class=\"transcript\"></div>\n")
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
