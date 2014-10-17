require 'spec_helper'

describe CustomCollectionItemDecorator do

  describe '#link_to_item_in_catalog' do
    it 'returns a link to the related catalog item, as identified by a solr document id' do
      item = build_stubbed(:custom_collection_item)
      link = CustomCollectionItemDecorator.new(item).catalog_link
      expect(link).to match(/^<a.*\/>$/).and match(/href=".*catalog\/.*"/)
    end
  end
end
