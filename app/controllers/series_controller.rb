class SeriesController < CatalogController
  
  include ContentController

  def browse_by_title
    @results = Blacklight.solr.select(params: {q: "has_model_ssim:info:fedora/afmodel:Series", rows: 10000})['response']['docs']

    # You can sort using Solr, but it defaults to being case sensitive, and putting numbers before letters.
    # This custom sort puts letters before numbers and is case insensitive.
    @results.sort! do |a, b|
      cmp_a = (a['title_tesim'].nil? || a['title_tesim'].empty?) ? '' : a['title_tesim'].first
      cmp_b = (b['title_tesim'].nil? || b['title_tesim'].empty?) ? '' : b['title_tesim'].first

      case
      # push titles beginning with numbers to the end
      when (/^[0-9]/ =~ cmp_a) && !(/^[0-9]/ =~ cmp_b)
        1
      when !(/^[0-9]/ =~ cmp_a) && (/^[0-9]/ =~ cmp_b)
        -1
      else
        cmp_a.upcase <=> cmp_b.upcase
      end
    end
    
    respond_to do |format|
      format.html {render :browse_by_title}
    end
  end
  
  def show
    @response, @document = get_solr_response_for_doc_id params[:id]
    @item  = ActiveFedora::Base.find(params[:id], cast: true) 
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
