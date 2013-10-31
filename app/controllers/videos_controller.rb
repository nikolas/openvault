class VideosController < CatalogController
  
  def show
    @response, @document = get_solr_document_by_slug(params[:id])    
    
    @rel = get_related_content(params[:id])
    @program = get_video_program(@document)
    @images = get_video_images(@document)
    @transcripts = get_video_transcripts(@document)
    
    #if current_user #or stale?(:last_modified => @document['system_modified_dtsi'])
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
   # end
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
  
  def get_video_program(document=nil)
    prog = []
    prog ||= get_only_solr_document_by_slug(document[:program_id_ssm])
  end
  
  def get_video_images(document=nil)
    images = []
    unless document[:video_images_ssm].nil?
      document[:video_images_ssm].each do |prog|
        images << get_only_solr_document_by_slug(prog.to_s)
      end
      
    end  
    images
  end
  
  def get_video_transcripts(document=nil)
    trans = []
    unless document[:video_transcript_ssm].nil?
      document[:video_transcript_ssm].each do |prog|
        trans << get_only_solr_document_by_slug(prog.to_s)
      end
      
    end  
    trans
  end
  
end