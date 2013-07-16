require 'spec_helper'

require 'openvault/datastreams'

# Here is a test class that includes the Openvault::Datastreams module
class TestDatastream < ActiveFedora::OmDatastream
  include Openvault::Datastreams
end

describe Openvault::Datastreams do

  let(:ov_datastream) { TestDatastream.new }
  let(:valid_xml) { File.read("#{fixture_path}/teams_asset_files/zoom.xml") }
  let(:invalid_xml) { 'I am not valid xml' }

  describe '#set_xml' do

    it 'does not raise an error when xml is valid' do
      expect{ov_datastream.set_xml(valid_xml)}.to_not raise_error
    end


    it 'raises an error when xml is invalid' do
      expect{ov_datastream.set_xml(invalid_xml)}.to raise_error
    end
  end


  describe '.get_encoding' do
    it 'returns value of "encoding" attribute of root xml node, if present.' do
      Openvault::Datastreams.get_encoding('<?xml version="1.0" encoding="iso-8859-1"?>').should == 'iso-8859-1'
    end

    it 'returns encoding (as string) of xml string if "encoding" attribute of root xml code is not present.' do
      xml_str = '<foo />'
      Openvault::Datastreams.get_encoding(xml_str).should == xml_str.encoding.to_s
    end
  end
end