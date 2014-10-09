require 'spec_helper'
require "#{RSpec.configuration.fixture_path}/pbcore/load_fixtures"

describe 'Media methods' do
  
  Fixtures.cwd("#{fixture_path}/pbcore")
  asset = OpenvaultAsset.new # no change: local variable is fine.
  asset.pbcore.ng_xml = Fixtures.use('pbcore_media.xml').ng_xml

  describe 'the easy ones' do
    %w(dimensions physical standard duration).each do |method|
      it method do
        # low level:
        expect(asset.pbcore.instantiation.send(method)).to eq ["some #{method}"]
        # high level:
        expect(asset.send("media_#{method}")).to eq "some #{method}"
      end
    end
  end

  describe 'the hard ones' do
    %w(type barcode).each do |method|
      it method do
        # low level interfaces are inconsistent for these.
        # high level:
        expect(asset.send("media_#{method}")).to eq "some #{method}"
      end
    end
  end
  
end