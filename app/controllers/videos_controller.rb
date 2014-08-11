class VideosController < CatalogController
  
  include ContentController
  
  def show
    @response, @document = get_solr_response_for_doc_id params[:id]
    @video  = Video.find params[:id]
    respond_to do |format|
      format.html #show.html.erb
      @document.export_formats.each_key do | format_name |
        # It's important that the argument to send be a symbol;
        # if it's a string, it makes Rails unhappy for unclear reasons. 
        format.send(format_name.to_sym) { render :text => @document.export_as(format_name), :layout => false }
      end
    end
  end
  
end