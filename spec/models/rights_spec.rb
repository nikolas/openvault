require 'spec_helper'
require "#{RSpec.configuration.fixture_path}/pbcore/load_fixtures"

describe 'Rights methods' do

  Fixtures.cwd("#{fixture_path}/pbcore")
  asset = OpenvaultAsset.new # no change: local variable is fine.
  asset.pbcore.ng_xml = Fixtures.use('pbcore_rights.xml').ng_xml

  %w(rights coverage credit holder note type).each do |method|
    it method do
      # low level:
      expect(asset.pbcore.rights.send(method)).to eq ["some #{method}"]
      # high level:
      expect(asset.send("rights_#{method}")).to eq "some #{method}"
    end
  end
  
end
