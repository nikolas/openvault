require 'spec_helper'
require 'openvault'
require "#{RSpec.configuration.fixture_path}/openvault/load_fixtures"

describe Openvault do

  describe '.ng_parse_options' do

    it 'raises an error when passed a non-integer' do
      expect{ Openvault.ng_parse_options = "foo" }.to raise_error
    end

    it 'defaults to Nokogiri::XML::ParseOptions::STRICT' do
      Openvault.ng_parse_options.should == Nokogiri::XML::ParseOptions::STRICT
    end
  end

  describe '::XML' do

    before(:each) { Fixtures.cwd "#{fixture_path}/openvault" }

    it 'returns an instance of Nokogiri::XML::Document' do
      Openvault::XML(Fixtures.raw('valid_xml.xml')).should be_a_kind_of(Nokogiri::XML::Document)
    end

    context 'when Openvault.ng_parse_options is set to "strict" mode' do
      before(:each) do
        Openvault.ng_parse_options = Nokogiri::XML::ParseOptions::STRICT
      end

      it 'will raise an error when Openvault.ng_parse_options is set to STRICT, and xml is invalid' do
        expect{ Openvault::XML(Fixtures.raw('invalid_xml.xml')) }.to raise_error
      end

      it 'will not raise an error when Openvault.ng_parse_options is set to STRICT, and xml is valid' do
        expect{ Openvault::XML(Fixtures.raw('valid_xml.xml')) }.to_not raise_error
      end
    end
  end
    
end