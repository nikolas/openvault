require 'spec_helper'
require 'openvault/pbcore'
require "#{RSpec.configuration.fixture_path}/pbcore/load_fixtures"

describe Openvault::Pbcore::OpenvaultAssetUpdater do

  # Helper method, specific for these tests.
  # Copies the pbcore xml from pbcore_desc_doc and saves
  # it to a new OpenvaultAsset.
  def saved_pbcore_desc_doc(pbcore_desc_doc=nil)

    # PbcoreDescDoc that is classifiable
    pbcore_desc_doc ||= build(:pbcore_desc_doc, :with_artesia_id, :with_program_title)
    
    # new OpenvaultAsset has a classifiable PbcoreDescDoc
    ov_asset = OpenvaultAsset.new
    ov_asset.pbcore.ng_xml = pbcore_desc_doc.ng_xml
    ov_asset.save!

    # return the persisted PbcoreDescDoc datastream object.
    ov_asset.pbcore
  end

  # Here we just need a PbcoreDescDoc that:
  #  1) Has an ID -- the :with_artesia_id is sufficient to satisfy this,
  #     but the fact that we chose an Artesia style ID is arbitrary.
  #  2) Is classifiable by AssetClassifier -- the :with_program_title
  #     option is sufficient to satify this, but the fact that we chose
  #     it to classify as Program is arbitrary.
  # let(:classifiable_pbcore_desc_doc) { build(:pbcore_desc_doc, :with_artesia_id, :with_program_title) }

  describe '#existing_openvault_asset' do

    describe 'when PbcoreDescDoc instance contains pbcoreIdentifiers that exist in exactly 1 Fedora object' do

      it 'returns a persisted OpenvaultAsset instance' do
        ov_asset = described_class.new(saved_pbcore_desc_doc).existing_openvault_asset
        expect(ov_asset).to be_a OpenvaultAsset
        expect(ov_asset.persisted?).to be true
      end

      it 'returns an OpenvaultAsset instance with the persisted pbcore, and not the updated pbcore' do
        pbcore_desc_doc = saved_pbcore_desc_doc

        # makes a new PbcoreDescDoc, using IDs from the saved PbcoreDescDoc
        updated_pbcore_desc_doc = build(:pbcore_desc_doc, all_ids: pbcore_desc_doc.all_ids)

        # changes the title, so we can make sure that #existing_openvault_asset does not have this change
        updated_pbcore_desc_doc.program_title = ['here is an updated program title']

        # get the #existing_openvault_asset, and expect it's pbcore xml to be the same as the original.
        ov_asset = described_class.new(updated_pbcore_desc_doc).existing_openvault_asset
        expect(ov_asset.pbcore.to_xml).to eq pbcore_desc_doc.to_xml
      end
    end

    describe 'when PbcoreDescDoc instance contains pbcoreIdentifiers that do not exist in any Fedora object' do
      it 'returns nil' do
        ov_asset = described_class.new(build(:pbcore_desc_doc, all_ids: 'unpersisted-pbcore-id')).existing_openvault_asset
        expect(ov_asset).to be_nil
      end
    end

    describe 'when PbcoreDescDoc instance contains pbcoreIdentifiers that exist in > 1 Fedora object' do

      let(:pbcore_desc_doc) do
        pbcore_desc_doc = saved_pbcore_desc_doc
        # and save and return the same pbcore xml again
        saved_pbcore_desc_doc(pbcore_desc_doc)
      end

      it 'raises a MultipleOpenvaultAssetsFound error' do
        expect{ described_class.new(pbcore_desc_doc).existing_openvault_asset }.to raise_error Openvault::Pbcore::OpenvaultAssetUpdater::MultipleOpenvaultAssetsFound
      end
    end

  end

  describe '#upated_openvault_asset' do

    let(:pbcore_desc_doc) { saved_pbcore_desc_doc }

    it 'returns the openvault asset with the updated pbcore xml' do
      updated_pbcore_desc_doc = build(:pbcore_desc_doc, all_ids: pbcore_desc_doc.all_ids)
      updated_pbcore_desc_doc.program_title = ['upated title']
      ov_asset = described_class.new(updated_pbcore_desc_doc).updated_openvault_asset
      expect(ov_asset.pbcore.to_xml).to eq updated_pbcore_desc_doc.to_xml
    end
  end

end
