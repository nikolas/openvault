require 'spec_helper'
require 'artesia'

describe Artesia do
  describe Artesia::Ingester do

    # Sample of Artesia XML contains 6 assets.
    let(:valid_xml) { File.read("#{fixture_path}/ingest/artesia.xml") }
    let(:invalid_xml) { 'this is not xml' }
    let(:depositor) { 'openvault_testing@wgbh.org' }

    it "ingests 1 record per asset, and 1 record representing the ingest as a whole" do
      count_before_ingest = ActiveFedora::Base.count
      Artesia::Ingester.ingest!(valid_xml, depositor)
      ActiveFedora::Base.count.should == (count_before_ingest + 7)
    end

    it "raises an error if xml is invalid" do
      expect {Artesia::Ingester.ingest!(invalid_xml, depositor)}.to raise_error
    end
  end

    
end