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
  	path = send("#{item.kind.downcase}_path", id)
  	link_to title, path, options
  end

  def render_collection_item(item, options={})
  	if item.kind == "Video"
  		render :partial => '/custom_collections/video', :locals => {:item => item}
  	else
  		render :partial => '/custom_collections/other', :locals => {:item => item}
  	end
  end
end
