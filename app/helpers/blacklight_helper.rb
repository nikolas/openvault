module BlacklightHelper
  include Blacklight::BlacklightHelperBehavior
  
  def render_search_context_options
    case 
      when params[:f]
      render :partial => 'catalog/search_context' 

      when (@document and @document.get(:objModels_s).include? "info:fedora/wgbh:COLLECTION")
        render :partial => 'catalog/search_context_collection' 
    end

  end
# 
  def render_document_partial(doc, action_name)
    format = self.send "document_#{action_name}_partial_name", doc if self.respond_to? "document_#{action_name}_partial_name"
    format ||= document_partial_name(doc)
    begin
      #enforce_rights(doc, action_name) 
      render :partial=>"catalog/_#{action_name}_partials/#{format}", :locals=>{:document=>doc}
    # rescue Openvault::PermissionDenied
#       render :partial=>"catalog/_#{action_name}_partials/permission_denied", :locals=>{:document=>doc}
    rescue ActionView::MissingTemplate
      render :partial=>"catalog/_#{action_name}_partials/default", :locals=>{:document=>doc}
    end
  end


  # def document_heading
  #   super.to_s.html_safe
  # end
# 
  def render_document_heading(document=@document, options={})
    render :partial => 'document_heading', :locals => { :document => document, :heading => document_heading }
  end
# 
  
  def render_xml_with_xslt xml, xslt
    require 'open-uri'
    xslt = Nokogiri::XSLT(open(xslt).read)
    xml = Nokogiri::XML(open(xml).read)
    xslt.transform(xml).to_s.html_safe
  end
  
  def render_tei_transcript source, options = {}
    render_xml_with_xslt(source, "public/xslt/tei2timedtranscript.xsl")
  end
  
  def render_video_player sources, options = {}
    options.symbolize_keys!
  
    options[:poster] &&= path_to_image(options[:poster]) 
    options[:id] ||= ((sources.first if sources.is_a?(Array)) || sources ).split('/').last.parameterize 
    options[:preload] ||= 'none'
  
    if size = options.delete(:size)
      options[:width], options[:height] = size.split("x") if size =~ /^\d+x\d+$/
    end
  
    html = ''

    if sources.is_a?(Array)
        html += content_tag("video", options) do
        sources.map { |source| tag("source", :src => source) }.join.html_safe
      end
    else
      options[:src] = sources
      html += tag("video", options)
    end    

    html += javascript_include_tag('openvault/player.js')

    html.html_safe
  end
  
  def display_title(doc=@document)
    return '' if (doc.nil? || doc['title_tesim'].try(:first).nil?)
    doc['title_tesim'].first
  end
  
  def display_summary(doc=@document)
    return '' if (doc.nil? || doc['summary_tesim'].try(:first).nil?)
    doc['summary_tesim'].first
  end

end
