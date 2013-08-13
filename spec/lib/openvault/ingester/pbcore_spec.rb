require 'spec_helper'
require 'openvault/ingester/pbcore'

describe Openvault::Ingester::Pbcore do

  describe '.ingest!' do

    let(:depositor) { 'openvault_test@wgbh.org' }
    let(:valid_xml_batch) { File.read("#{fixture_path}/pbcore/MARS_Programs.xml") }

    it "saves one OpenvaultAsset for every pbcoreDescriptionDocument node in the xml." do
      count_before = OpenvaultAsset.count
      Openvault::Ingester::Pbcore.ingest!(valid_xml_batch, depositor)
      OpenvaultAsset.count.should == (count_before + 30)
    end

    it "does not raise an error when given valid xml with a single pbcoreCollection node containing multiple pbcoreDescriptionDocument nodes." do
      expect{ Openvault::Ingester::Pbcore.ingest!(valid_xml_batch, depositor) }.to_not raise_error
    end
  end
    
end