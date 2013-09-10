require 'spec_helper'
require 'openvault'
require 'openvault/mars'
require 'openvault/ingester/mars'
require "#{RSpec.configuration.fixture_path}/mars/load_fixtures"

describe Openvault::Ingester::MARS do

  let(:depositor) { 'openvault_test@wgbh.org' }

  before(:all) { Openvault::Ingester::MARS.delete_tmp_files('*') }
  before(:each) { Fixtures.cwd "#{fixture_path}/mars" }

  it 'deletes temporary mars record files after ingest by default' do
    Openvault::Ingester::MARS.ingest!(:assets, :files => Fixtures.file_path('asset_1.xml'), :depositor => depositor)
    Openvault::Ingester::MARS.tmp_filenames.count.should == 0
  end
end