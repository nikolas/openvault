module CustomCollectionItemHelper

  def collection_item_link(item, html_options={})
    # If solr gets outta whack, there may not be a value for item.catalog path, hence the '#' fallback.
    link_title = "#{item.title} - #{item.kind}"
    link_to_if(item.catalog_path, link_title, item.catalog_path, html_options) do
      link_title
    end
  end

  def collection_item_path(item)
    item.kind.downcase
  end

  # TODO: Is it OK to have Fedora lookup in this helper method?
  def render_collection_item(item, options={})
    partial_name = (item.kind == "Video") ? 'video' : 'other'
    render partial: "/custom_collections/#{partial_name}", locals: {item: item }
  end
end