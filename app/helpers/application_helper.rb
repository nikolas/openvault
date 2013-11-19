module ApplicationHelper
  include Twitter::Autolink
  def organization_name
    Rails.configuration.organization_name
  end
  
  def title(page_title, options={})
    content_for(:title, page_title.to_s)
    return content_tag(:h1, page_title, options)
  end
  
end
