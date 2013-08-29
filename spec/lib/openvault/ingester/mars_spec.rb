require 'spec_helper'
require 'openvault'
require 'openvault/mars'
require 'openvault/ingester/mars'
require "#{RSpec.configuration.fixture_path}/mars/load_fixtures"

describe Openvault::Ingester::MARS do

  before(:each) { Fixtures.cwd "#{fixture_path}/mars" }

  # describe '.prepare_ingest_files' do
  #   context 'when input is one filename (a string),' do
  #     it 'returns an array with that filename' do

  #     end
  #   end

  #   context 'when input is an array of filenames,' do
  #     it 'returns that array (does nothing)' do
  #     end
  #   end

  #   context 'when input is a string,' do
  #     it 'creates a temporary file, writes the string to it, and returns an array with the temp filename' do
  #     end
  #   end

  #   context 'when input is multiple string,' do
  #     it 'writes the strings to temporary files, and returns an array of those filenames' do
  #     end
  #   end
  # end

  describe '.tmp_dir' do
    it 'has a default value' do
      Openvault::Ingester::MARS.tmp_dir.should_not be_nil
    end

    it 'can be set' do
      Openvault::Ingester::MARS.tmp_dir = "blergifoo"
      Openvault::Ingester::MARS.tmp_dir.should == "blergifoo"
    end
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
      
      pending "saves one OpenvaultAsset for every MARS record in a single xml string." do
        count_before = OpenvaultAsset.count
        input = Fixtures.raw('asset_x3.xml')
        Openvault::Ingester::MARS.ingest!(:assets, :xml => input, :depositor => depositor)
        OpenvaultAsset.count.should == (count_before + 3)
      end
      
      pending "saves one OpenvaultAsset for every MARS record in multiple xml strings." do
        count_before = OpenvaultAsset.count
        input = [Fixtures.raw('asset_1.xml'), Fixtures.raw('assets_x3.xml')]
        Openvault::Ingester::MARS.ingest!(:assets, :xml => input, :depositor => depositor)
        OpenvaultAsset.count.should == (count_before + 4)
      end

    end

  end
end