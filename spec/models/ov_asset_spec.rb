# Generated via
#  `rails generate active_fedora::model OvAsset`
require 'spec_helper'
require 'active_fedora/test_support'

describe OvAsset do
  it_behaves_like 'An ActiveModel'
  include ActiveFedora::TestSupport
  subject { OvAsset.new }

  describe "when persisted to fedora" do
    before { subject.save! }
    after { subject.destroy }
    it 'should exist' do
      OvAsset.exists?(subject.pid).should be_true
    end
  end

  it 'should have a descMetadata datastream' do
    subject.descMetadata.should be_kind_of OvAssetMetadata
  end

end
