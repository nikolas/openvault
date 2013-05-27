require 'spec_helper'

describe ArtesiaIngest do

  let!(:valid_file) { File.open("#{fixture_path}/ingest/artesia.xml") }
  let!(:invalid_file) { File.open("#{fixture_path}/ingest/malformed.xml") }

  subject(:ingest) { ArtesiaIngest.new }


  it "saves a datastream for source xml" do
    xml = valid_file.read
    ingest.teams_asset_file.ng_xml = Nokogiri::XML(xml)
    ingest.save!
    compare = Datastream::TeamsAssetFile.new
    compare.ng_xml = Nokogiri::XML(xml)
    ingest.teams_asset_file.to_xml.should == compare.to_xml
  end


  # # TODO: move to module?
  # describe '#attach_input_file' do

  #   context 'with valid xml' do
  #     it 'sets mime-type and content of file datastream' do
  #       ingest.attach_input_file(valid_file)
  #       ingest.input_file.content.should_not be_nil
  #       ingest.input_file.mimeType.should == "text/xml"
  #     end      
  #   end

  #   context "with invalid xml" do
  #     it 'raises an error' do
  #       expect { ingest.attach_input_file(invalid_file) }.to raise_error
  #     end
  #   end

  #   context "with invalid File" do
  #     it 'raises an error' do
  #       expect { ingest.attach_input_file(invalid_file) }.to raise_error
  #     end
  #   end
  # end



  # describe '#run!' do

  #   context 'without any content in the input_file datastream' do
  #     it "raises an error" do
  #       expect { ingest.run! }.to raise_error
  #     end
  #   end


  #   context 'with a valid xml file attached' do
  #     it "creates and saves OpenvaultAssets from xml" do
  #       ingest.attach_input_file(valid_file)
  #       ingest.run!
  #     end
  #   end
  # end
end