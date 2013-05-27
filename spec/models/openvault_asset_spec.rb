require 'spec_helper'

describe OpenvaultAsset do


  let(:valid_file) { File.open("#{fixture_path}/ingest/uois.xml") }

  subject (:asset) { OpenvaultAsset.new }


  it "saves a datastream for UOIS xml" do
    xml = valid_file.read
    asset.uois.ng_xml = Nokogiri::XML(xml)
    asset.save!
    compare = Datastream::UOIS.new
    compare.ng_xml = Nokogiri::XML(xml)
    asset.uois.to_xml.should == compare.to_xml
  end
end