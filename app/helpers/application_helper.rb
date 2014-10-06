module ApplicationHelper
  include Twitter::Autolink

  def organization_name
    Rails.configuration.organization_name
  end
  
  def title(page_title, options={})
    content_for(:title, page_title.to_s)
    return content_tag(:h1, page_title, options)
  end

  def collection_item_link(item, options={})
  	id = item.solr_doc['id']
  	title = "#{item.solr_doc['title_tesim'].first} - #{item.kind}"
  	path = catalog_path(id)
  	link_to title, path, options
  end

  def collection_item_path(item)
    item.kind.downcase
  end

  # TODO: Is it OK to have Fedora lookup in this helper method?
  def render_collection_item(item, options={})
    partial_name = (item.kind == "Video") ? 'video' : 'other'
    begin
      ov_asset = ActiveFedora::Base.find(item.openvault_asset_pid, cast: true)
      render partial: "/custom_collections/#{partial_name}", locals: {item: item, ov_asset: ov_asset}
    rescue
      Rails.logger.error "Failed render of '#{partial_name}' for PID '#{item.openvault_asset_pid}'"
    end
  end
end
