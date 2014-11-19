require 'spec_helper'

describe TeiDatastream do
  describe 'factory' do
    it 'builds an instance of TeiDatastream' do
      expect(build(:tei_datastream)).to be_a TeiDatastream
    end
  end

  describe '#ng_xml' do

    let(:tei_datastream) { build(:tei_datastream) }

    it 'returns a Nokogiri::XML::Document' do
      expect(tei_datastream.ng_xml).to be_a Nokogiri::XML::Document
    end

    it 'has a <TEI /> root element' do
      expect( tei_datastream.ng_xml.root.name ).to eq 'TEI'
    end
  end
end