require 'spec_helper'

require 'openvault/datastream'

# Here is a test class that includes the Openvault::Datastreams module
class TestDatastream < ActiveFedora::OmDatastream
  include Openvault::Datastream
end

describe Openvault::Datastream do

  let(:ov_datastream) { TestDatastream.new }
  let(:valid_xml) { File.read("#{Fixtures.base_dir}/artesia/zoom/teams_asset_file.xml") }
  let(:invalid_xml) { 'I am not valid xml' }

  describe '#set_xml' do

    it 'does not raise an error when xml is valid' do
      expect{ov_datastream.set_xml(valid_xml)}.to_not raise_error
    end


    it 'raises an error when xml is invalid' do
      expect{ov_datastream.set_xml(invalid_xml)}.to raise_error
    end
  end

  describe '.uois_to_pbcore' do
    pending 'converts UOIS xml to PBCore xml'
  end
end