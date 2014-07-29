class AudiosController < CatalogController
  
  require 'concerns/content_controller.rb'
  include ContentController
  
  def show
    @response, @document = get_solr_response_for_doc_id params[:id]
    
    @rel = get_related_content(params[:id])

    @audio = Audio.find params[:id]

    @program = get_audio_program(@document)
    @images = get_audio_images(@document)
  
    
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
  
  protected
  
  def get_audio_program(document=nil)
    prog = get_only_solr_document_by_slug(document[:program_id_ssm])
  end
  
  def get_audio_images(document=nil)
    images = []
    unless document[:audio_images_ssm].nil?
      document[:audio_images_ssm].each do |prog|
        images << get_only_solr_document_by_slug(prog.to_s)
      end
      
    end  
    images
  end
  
  
end
