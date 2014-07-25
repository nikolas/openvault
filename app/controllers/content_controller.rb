class ContentController < CatalogController
  
  def cite
    @response, @document = get_solr_response_for_doc_id
    respond_to do |format|
      format.html {render :layout => 'blank'}
    end
  end
  
end
