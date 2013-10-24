require 'spec_helper'
require 'openvault/ingester/pbcore'

describe Openvault::Ingester::Pbcore do

  before(:all) { require "#{fixture_path}/pbcore/load_fixtures" }

  before(:each) { Fixtures.cwd "#{fixture_path}/pbcore" }

  describe '.ingest!' do

    it "saves one OpenvaultAsset for every pbcoreDescriptionDocument node in the xml." do
      count_before = OpenvaultAsset.count
      Openvault::Ingester::Pbcore.ingest!(Fixtures.raw('mars/programs_1.xml'))
      OpenvaultAsset.count.should == (count_before + 30)
    end

    it "does not raise an error when given valid xml with a single pbcoreCollection node containing multiple pbcoreDescriptionDocument nodes." do
      expect{ Openvault::Ingester::Pbcore.ingest!(Fixtures.raw('mars/programs_1.xml')) }.to_not raise_error
    end

    it 'returns array of OpenvaultAsset models just ingested' do
      ov_assets = Openvault::Ingester::Pbcore.ingest!(Fixtures.raw('mars/programs_1.xml') )
      ov_assets.each do |ov_asset|
        ov_asset.should be_kind_of OpenvaultAsset
      end
    end
  end
    
end