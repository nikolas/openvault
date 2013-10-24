class SeriesController < CatalogController
  
  def show
    @response, @document = get_solr_document_by_slug(params[:id])    
    #@repspones, @document = get_solr_response_for_doc_id
    
    @rel = get_related_content(params[:id])
    
    @programs = get_programs(@document)
    
    respond_to do |format|
      #format.html {setup_next_and_previous_documents}
      format.html #show.html.erb
      #format.jpg { send_data File.read(@document.thumbnail.path(params)), :type => 'image/jpeg', :disposition => 'inline' }
  
      # Add all dynamically added (such as by document extensions)
      # export formats.
      @document.export_formats.each_key do | format_name |
        # It's important that the argument to send be a symbol;
        # if it's a string, it makes Rails unhappy for unclear reasons. 
        format.send(format_name.to_sym) { render :text => @document.export_as(format_name), :layout => false }
      end
    end
  end
  
  def print
    @response, @document = get_solr_response_for_doc_id    
    respond_to do |format|
      format.html {setup_next_and_previous_documents}
    end
  end

  def embed
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

  def cite
    @response, @document = get_solr_response_for_doc_id    
    respond_to do |format|
      format.html {render :layout => 'blank'}
    end
  end
  
  protected
  
  def get_only_solr_document_by_slug(slug=nil)
    q = "slug:#{slug}"
    solr_params = {
      :defType => "edismax",   # need boolean for OR
      :q => q,
    }
    solr_response = find('document', self.solr_search_params().merge(solr_params) )
    document_list = solr_response.docs.collect{|doc| SolrDocument.new(doc, solr_response) }
    document_list.first
  end
  
  def get_programs(document=nil)
    progs = []
    unless document[:programs_ssm].nil?
      document[:programs_ssm].each do |prog|
        progs << get_only_solr_document_by_slug(prog.to_s)
      end
      progs
    end
  end
  
end