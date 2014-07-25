class ContentController < CatalogController
  
  def cite
    @response, @document = get_solr_response_for_doc_id
    respond_to do |format|
      format.html {render :layout => 'blank'}
    end
  end
  
  def print
    @response, @document = get_solr_response_for_doc_id
    respond_to do |format|
      format.html {setup_next_and_previous_documents}
    end
  end
  
end
