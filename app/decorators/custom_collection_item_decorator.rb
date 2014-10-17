class CustomCollectionItemDecorator < Draper::Decorator



  def catalog_path
    "/catalog/#{solr_doc['slug'] || solr_doc['id']}" if solr_doc
  end

  def catalog_link
    link_title = "#{object.title} - #{object.kind}"
    link_to_if(object.catalog_path, link_title, object.catalog_path, html_options) do
      link_title
    end
  end

end
