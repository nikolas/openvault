require 'spec_helper'
require 'openvault'

describe Openvault::Ingester::Artesia do

  let(:valid_xml) { File.read("#{fixture_path}/artesia_ingest/uois.zoom_sample.xml") }
  let(:depositor) { 'openvault_test@wgbh.org' }

  describe '#ingest!' do
    it "ingests without error when given valid xml and depositor" do
      expect{Openvault::Ingester::Artesia.ingest!(valid_xml, depositor)}.to_not raise_error
    end
  end
    
end