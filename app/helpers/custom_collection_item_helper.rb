module CustomCollectionItemHelper

  def collection_item_link(item, options={})
    if item
      id = item.solr_doc['id']
      title = "#{item.solr_doc['title_tesim'].first} - #{item.kind}"
      path = catalog_path(id)
      link_to title, path, options
    else
      # It OUGHT to be there, but that's false so often that we want to be graceful.
    end
  end

  def collection_item_path(item)
    item.kind.downcase
  end

  # TODO: Is it OK to have Fedora lookup in this helper method?
  def render_collection_item(item, options={})
    partial_name = (item.kind == "Video") ? 'video' : 'other'
    render partial: "/custom_collections/#{partial_name}", locals: {item: item, ov_asset: item.ov_asset}
  end
end