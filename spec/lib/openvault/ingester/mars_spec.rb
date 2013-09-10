require 'spec_helper'
require 'openvault'
require 'openvault/mars'
require 'openvault/ingester/mars'
require "#{RSpec.configuration.fixture_path}/mars/load_fixtures"

describe Openvault::Ingester::MARS do

  before(:each) { Fixtures.cwd "#{fixture_path}/mars" }


  describe '.tmp_dir=' do
    it 'raises an error if you try to set the tmp_dir to something that is not a directory' do
      expect{Openvault::Ingester::MARS.tmp_dir = "asdfasdfasdfasdsafasfsadf"}.to raise_error
    end
  end

  describe '.parallel' do
    it 'raises an error if you try to set `parallel` to something that cannot be converted to an integer with to_i' do
      expect{Openvault::Ingester::MARS.parallel = "foo"}
    end
  end


  context 'when handling temporary files for ingest' do

    # Delete all temp mars record files before and after each example in this context.
    around(:each) { Openvault::Ingester::MARS.delete_tmp_files('*') }


    describe '.delete_tmp_files' do
      it 'deletes all files from tmp dir' do
        glob = Openvault::Ingester::MARS.tmp_filename('*')
        Dir[glob].count.should == 0
      end
    end

    describe '.write_mars_record_files' do
      it 'writes out a temporary file for each mars record in an input file' do
        Openvault::Ingester::MARS.write_mars_record_files(Fixtures.file_path('assets_x3.xml'))
        glob = Openvault::Ingester::MARS.tmp_filename('*')
        Dir[glob].count.should == 3
      end

      it 'ensures that each temporary file has a namespace so that it can be translated to pbcore via Openvault::MARS.to_pbcore' do
        # write a temporary mars record file from Fixture
        Openvault::Ingester::MARS.write_mars_record_files(Fixtures.file_path('asset_1.xml'))
        # get the temp mars record filename
        tmp_filename = Openvault::Ingester::MARS.tmp_filename(1)
        # parse the temp mars record with nokogiri and ensure that it has a namespace.
        mars_ng = Openvault::XMLasdfasfsdf(File.read(tmp_filename))
        mars_ng.namespaces.should_not be_empty
      end
    end
  end


  it 'ensures that each temporary file has a namespace so that it can be translated to pbcore via Openvault::MARS.to_pbcore' do
    # write a temporary mars record file from Fixture
    tmp_filename = Openvault::Ingester::MARS.write_mars_record_files(Fixtures.file_path('asset_1.xml')).first

    input_xml_doc = Openvault::XML(Fixtures.raw('asset_1.xml'))
    temp_xml_doc = Openvault::XML(File.read(tmp_filename))

    input_xml_doc.namespaces.count.should be >= 1
    input_xml_doc.namespaces.should == temp_xml_doc.namespaces
  end


  describe '.ingest!' do

    let(:depositor) { 'openvault_test@wgbh.org' }


    context 'for the "assets" MARS table,' do
      
      it "saves one OpenvaultAsset for every MARS record in a single file." do
        count_before = OpenvaultAsset.count
        input = Fixtures.file_path('assets_x3.xml')
        Openvault::Ingester::MARS.ingest!(:assets, :files => input, :depositor => depositor)
        OpenvaultAsset.count.should == (count_before + 3)
      end
      
      it "saves one OpenvaultAsset for every record in multiple files." do
        count_before = OpenvaultAsset.count
        input = [Fixtures.file_path('asset_1.xml'), Fixtures.file_path('assets_x3.xml')]
        Openvault::Ingester::MARS.ingest!(:assets, :files => input, :depositor => depositor)
        OpenvaultAsset.count.should == (count_before + 4)
      end

    end

    context 'when :return option is :objects' do
      it 'returns an array of OpenvaultAsset models' do
        objects = Openvault::Ingester::MARS.ingest!(:assets, :files => Fixtures.file_path('assets_x3.xml'), :depositor => depositor, :return => :objects)
        objects.each do |obj|
          obj.should be_kind_of OpenvaultAsset
        end
      end
    end

    context 'when :return option is :pids' do
      it 'returns an array of OpenvaultAsset models' do
        pids = Openvault::Ingester::MARS.ingest!(:assets, :files => Fixtures.file_path('assets_x3.xml'), :depositor => depositor, :return => :pids)
        pids.each do |pid|
          pid.should be_kind_of String
        end
      end
    end

    context 'when :return option is :count' do
      it 'returns an array of OpenvaultAsset models' do
        count = Openvault::Ingester::MARS.ingest!(:assets, :files => Fixtures.file_path('assets_x3.xml'), :depositor => depositor, :return => :count)
        count.should == 3
      end
    end

    it 'saves MARS xml from temp file created during ingest to datastream on OpenvaultAsset#source_xml' do
      # First, delete the temp mars record files so the tmp dir is empty.
      Openvault::Ingester::MARS.delete_tmp_files('*')

      # Ingest from fixture, return pids
      pids = Openvault::Ingester::MARS.ingest!(:assets, :files => Fixtures.file_path('asset_1.xml'), :depositor => depositor, :keep_mars_record_files => true, :return => :pids)

      OpenvaultAsset.find(pids.first).source_xml.content.should == File.read(Openvault::Ingester::MARS.tmp_filenames.first)
    end

  end
end