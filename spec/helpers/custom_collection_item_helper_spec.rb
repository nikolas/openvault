require 'spec_helper'

describe CustomCollectionItemHelper do
  describe '#collection_item_link' do

    let(:item) { CustomCollectionItem.new }

    it 'returns a link to the collection item in the catalog, if it has a corresponding solr doc.' do
      allow(item).to receive(:solr_doc) { {'id' => 'foo'} }
      allow(item).to receive(:title) { 'bar' }
      expect(collection_item_link(item)).to match(/<a.*>/).and match(/#{item.title}/).and match(/href=".*catalog\/foo.*"/)
    end

    it 'returns the title of the collection item (not linked), if it does not have a path to the catalog item' do
      # If the solr doc does not exist, then something went wrong. But let's have a sensible fallback: output the title but don't try to link it.
      allow(item).to receive(:solr_doc) { nil }
      expect(collection_item_link(item)).to match(/#{item.title}/)
      expect(collection_item_link(item)).not_to match(/<a.*>/)
    end

  end
end