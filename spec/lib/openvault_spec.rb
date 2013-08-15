require 'spec_helper'
require 'openvault'

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

    let(:valid_xml) { File.read("#{Fixtures.base_dir}/openvault/valid_xml.xml") }
    let(:invalid_xml) { File.read("#{Fixtures.base_dir}/openvault/invalid_xml.xml") }

    it 'returns an instance of Nokogiri::XML::Document' do
      Openvault::XML(valid_xml).should be_a_kind_of(Nokogiri::XML::Document)
    end

    context 'when Openvault.ng_parse_options is set to "strict" mode' do
      before(:each) do
        Openvault.ng_parse_options = Nokogiri::XML::ParseOptions::STRICT
      end

      it 'will raise an error when Openvault.ng_parse_options is set to STRICT, and xml is invalid' do
        expect{ Openvault::XML(invalid_xml) }.to raise_error
      end

      it 'will not raise an error when Openvault.ng_parse_options is set to STRICT, and xml is valid' do
        expect{ Openvault::XML(valid_xml) }.to_not raise_error
      end
    end
  end
    
end