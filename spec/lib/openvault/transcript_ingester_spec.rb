require 'spec_helper'
require 'openvault/transcript_ingester'
require "#{RSpec.configuration.fixture_path}/pbcore/load_fixtures"

describe Openvault::TranscriptIngester do
  
  before(:each) do
    Fixtures.cwd("#{fixture_path}/pbcore")
  end

  let(:transcript) do
    transcript = Transcript.new
    transcript.pbcore.ng_xml = Fixtures.use('artesia/rock_and_roll/transcript_1.xml').ng_xml
    transcript
  end

  describe '.logger=' do
    it 'sets @logger to an instance of Logger' do
      expect{ Openvault::TranscriptIngester.logger = Logger.new(STDOUT) }.to_not raise_error
    end

    it 'raises an error if you attempt to pass something other than Logger' do
      expect{ Openvault::TranscriptIngester.logger = true }.to raise_error ArgumentError
    end
  end

  describe '.ingest_tei_xml_specified_by_pbcore!' do
    it 'reads the file specified by pbcore metdata, and assigns it to the TeiDatastream of the Transcript model' do
      # The test here is to check for a <teiHeader> node in the TeiDatastream that belongs to the Transcript model.
      expect(transcript.tei.ng_xml.xpath('//teiHeader').count).to eq(0), "TeiDatastream of the Transcript model should not contain any TEI xml before ingestion."
      Openvault::TranscriptIngester.ingest_tei_xml_specified_by_pbcore(transcript, "#{fixture_path}/tei")
      expect(transcript.tei.ng_xml.xpath('//teiHeader').count).to eq(0), "TeiDatastream of the Transcript model should contain any TEI xml after ingestion."
    end
  end
end