require 'spec_helper'
require 'openvault/pbcore'
require "#{RSpec.configuration.fixture_path}/pbcore/load_fixtures"

describe Openvault::Pbcore::OpenvaultAssetFetcher do

  describe '#openvault_asset' do

    # Helper method, specific for these tests.
    # Saves n OpenvaultAsset instances with pbcore_desc_doc as the pbcore datastream.
    def save_pbcore_n_times(pbcore_desc_doc, n=0)
      n.times do
        ov_asset = OpenvaultAsset.new
        ov_asset.pbcore.ng_xml = pbcore_desc_doc.ng_xml
        ov_asset.save!
      end
      pbcore_desc_doc
    end

    # Here we just need a PbcoreDescDoc that:
    #  1) Has an ID -- the :with_artesia_id is sufficient to satisfy this,
    #     but the fact that we chose an Artesia style ID is arbitrary.
    #  2) Is classifiable by AssetClassifier -- the :with_program_title
    #     option is sufficient to satify this, but the fact that we chose
    #     it to classify as Program is arbitrary.
    let(:classifiable_pbcore_desc_doc) { build(:pbcore_desc_doc, :with_artesia_id, :with_program_title) }

    describe 'when PbcoreDescDoc instance contains pbcoreIdentifiers that exist in exactly 1 Fedora object' do

      let(:pbcore_desc_doc) { save_pbcore_n_times(classifiable_pbcore_desc_doc, 1) }

      it 'returns a persisted OpenvaultAsset instance' do
        ov_asset = described_class.new(pbcore_desc_doc).openvault_asset
        expect(ov_asset).to be_a OpenvaultAsset
        expect(described_class.new(pbcore_desc_doc).openvault_asset.persisted?).to be true
      end
    end

    describe 'when PbcoreDescDoc instance contains pbcoreIdentifiers that do not exist in any Fedora object' do

      let(:pbcore_desc_doc) { save_pbcore_n_times(classifiable_pbcore_desc_doc, 0) }

      it 'returns an unpersisted OpenvaultAsset instance' do
        ov_asset = described_class.new(pbcore_desc_doc).openvault_asset
        expect(ov_asset).to be_a OpenvaultAsset
        expect(described_class.new(pbcore_desc_doc).openvault_asset.persisted?).to be false
      end
    end

    describe 'when PbcoreDescDoc instance contains pbcoreIdentifiers that exist in > 1 Fedora object' do

      let(:pbcore_desc_doc) { save_pbcore_n_times(classifiable_pbcore_desc_doc, 2) }

      it 'raises a MultipleOpenvaultAssetsFound error' do
        expect{ described_class.new(pbcore_desc_doc).openvault_asset }.to raise_error Openvault::Pbcore::OpenvaultAssetFetcher::MultipleOpenvaultAssetsFound
      end
    end

  end

end
