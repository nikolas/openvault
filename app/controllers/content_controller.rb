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
  
  def embed
    byebug
    @response, @document = get_solr_response_for_doc_id
    @width = params[:width].try(:to_i) || 640
    @height = params[:height].try(:to_i) || (3 * @width / 4)
    respond_to do |format|
      format.html {render :layout => 'embed' }

      # Add all dynamically added (such as by document extensions)
      # export formats.
      @document.export_formats.each_key do | format_name |
        # It's important that the argument to send be a symbol;
        # if it's a string, it makes Rails unhappy for unclear reasons.
        format.send(format_name.to_sym) { render :text => @document.export_as(format_name) }
      end

    end
  end

end
