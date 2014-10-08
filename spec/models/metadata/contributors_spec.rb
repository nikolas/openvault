require 'spec_helper'
require "#{RSpec.configuration.fixture_path}/pbcore/load_fixtures"

describe 'contributions_by_role' do
  
  Fixtures.cwd("#{fixture_path}/pbcore")
  asset = OpenvaultAsset.new # no change: local variable is fine.
  asset.pbcore.ng_xml = Fixtures.use('pbcore_contributors.xml').ng_xml

  it 'works' do
    expect(asset.contributions_by_role).to eq({
      'Helper' => ['Doe, John [Some Institution]', 'Smith, Jane'],
      'Big Wig' => ['Doe, John [Some Institution]'],
      'Small Wig' => ['Smith, Jane'],
      'President' => ['Washington, George [Mt. Vernon]']
    })
  end
  
end