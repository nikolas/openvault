require 'spec_helper'
require "#{RSpec.configuration.fixture_path}/pbcore/load_fixtures"

describe 'Subject method' do
  
  Fixtures.cwd("#{fixture_path}/pbcore")
  asset = OpenvaultAsset.new # no change: local variable is fine.
  asset.pbcore.ng_xml = Fixtures.use('pbcore_subject.xml').ng_xml

  it 'low level works' do
    expect(asset.pbcore.subjectsNested).to eq ['complicated']
    expect(asset.pbcore.subjectsNotNested).to eq ['simple']
  end
  it 'high level works' do
    expect(asset.subjects).to eq ['simple', 'complicated']
  end
end