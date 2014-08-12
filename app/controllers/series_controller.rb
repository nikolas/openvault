class SeriesController < ApplicationController
  
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

end
