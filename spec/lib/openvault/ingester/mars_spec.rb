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


  context 'when handling temporary files for ingest' do

    # Delete all temp mars record files before and after each example in this context.
    around(:each) { Openvault::Ingester::MARS.delete_mars_record_files }


    describe '.delete_mars_record_files' do
      it 'deletes all temporary files for storing mars records' do
        glob = Openvault::Ingester::MARS.mars_record_filename('*')
        Dir[glob].count.should == 0
      end
    end

    describe '.next_mars_record_filename' do
      context 'when tmp dir is empty' do
        it 'returns the temp filename with suffix of "1"' do
          Openvault::Ingester::MARS.next_mars_record_filename.should == Openvault::Ingester::MARS.mars_record_filename(1)
        end
      end

      context 'when tmp contans temp files with sequential suffix' do
        it 'returns the temp filename with suffix that is next in the sequence' do
          # Write a couple of fake files
          File.write(Openvault::Ingester::MARS.mars_record_filename(1), "blah")
          File.write(Openvault::Ingester::MARS.mars_record_filename(2), "blah")
          Openvault::Ingester::MARS.next_mars_record_filename.should == Openvault::Ingester::MARS.mars_record_filename(3)
        end
      end

      context 'when tmp contans temp files with nont-sequential suffix' do
        it 'returns the temp filename with suffix that is next in the sequence of the lowest ordered suffix' do
          # Write a couple of fake files
          File.write(Openvault::Ingester::MARS.mars_record_filename(1), "blah")
          File.write(Openvault::Ingester::MARS.mars_record_filename(100), "blah")
          Openvault::Ingester::MARS.next_mars_record_filename.should == Openvault::Ingester::MARS.mars_record_filename(2)
        end
      end
    end

    describe '.write_mars_record_files' do
      it 'writes out a temporary file for each mars record in an input file' do
        Openvault::Ingester::MARS.write_mars_record_files(Fixtures.file_path('assets_x3.xml'))
        glob = Openvault::Ingester::MARS.mars_record_filename('*')
        Dir[glob].count.should == 3
      end

      it 'ensures that each temporary file has a namespace so that it can be translated to pbcore via Openvault::MARS.to_pbcore' do
        # write a temporary mars record file from Fixture
        Openvault::Ingester::MARS.write_mars_record_files(Fixtures.file_path('asset_1.xml'))

        # get the temp mars record filename
        mars_record_filename = Openvault::Ingester::MARS.mars_record_filename(1)

        # parse the temp mars record with nokogiri and ensure that it has a namespace.
        mars_ng = Openvault::XMLasdfasfsdf(File.read(mars_record_filename))

        debugger

        mars_ng.namespaces.should_not be_empty
      end
    end
  end


  it 'ensures that each temporary file has a namespace so that it can be translated to pbcore via Openvault::MARS.to_pbcore' do
    # write a temporary mars record file from Fixture
    mars_record_filename = Openvault::Ingester::MARS.write_mars_record_files(Fixtures.file_path('asset_1.xml')).first

    input_xml_doc = Openvault::XML(Fixtures.raw('asset_1.xml'))
    temp_xml_doc = Openvault::XML(File.read(mars_record_filename))

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

    it 'returns an array of OpenvaultAsset models' do
      ov_assets = Openvault::Ingester::MARS.ingest!(:assets, :files => Fixtures.file_path('asset_1.xml'), :depositor => depositor)
      ov_assets.each do |ov_asset|
        ov_asset.should be_kind_of OpenvaultAsset
      end
    end

    it 'deletes temporary mars record files after ingest by default' do
      Openvault::Ingester::MARS.ingest!(:assets, :files => Fixtures.file_path('asset_1.xml'), :depositor => depositor)
      glob = Openvault::Ingester::MARS.mars_record_filename('*')
      Dir[glob].count.should == 0
    end

    it 'saves MARS xml from temp file created during ingest to datastream on OpenvaultAsset#source_xml' do
      # First, delete the temp mars record files so the tmp dir is empty.
      Openvault::Ingester::MARS.delete_mars_record_files

      # Ingest from fixture
      ov_assets = Openvault::Ingester::MARS.ingest!(:assets, :files => Fixtures.file_path('assets_x3.xml'), :depositor => depositor, :keep_mars_record_files => true)

      # For each of the saved OpenvaultAsset models...
      for i in 1..ov_assets.count
        # Look up the OpenvaultAsset by pid and compare the `source_xml.content` to
        # the xml from the temporary mars record file that was used for ingest.
        mars_record_filename = Openvault::Ingester::MARS.mars_record_filename(i)
        OpenvaultAsset.find(ov_assets[i-1].pid).source_xml.content.should == File.read(mars_record_filename)
      end
    end

  end
end