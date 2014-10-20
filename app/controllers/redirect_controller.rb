class RedirectController < ApplicationController
  
  def redirect_series_name
    target = 
      case params[:name]
      when 'Say+Brother'
        '/catalog/sbro-say-brother'
      when "Ten+O'Clock+News"
        '/catalog/tocn-the-ten-o-clock-news'
      when 'New+Television+Workshop'
        '/collections/ntw-the-new-television-workshop'
      when 'War+and+Peace+in+the+Nuclear+Age'
        '/catalog/wpna-wpna-war-and-peace-in-the-nuclear-age'
      end
    if target
      redirect_to target
    else
      render_404
    end
  end
    
  def redirect_series_mla
    
  end
  
  def redirect_wapina_barcode
    
  end
  
  private
  
  def render_404
    render 'catalog/no_record_found', status: :not_found, formats: :html
  end
  
end
