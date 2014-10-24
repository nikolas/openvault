class RedirectController < ApplicationController
  
  SAY = '/catalog/sbro-say-brother'
  TEN = 'http://bostonlocaltv.org/wgbh'
  NTW = '/collections/ntw-the-new-television-workshop'
  NUKES = '/catalog/wpna-wpna-war-and-peace-in-the-nuclear-age'
  
  def redirect_series_name
    target = 
      case params[:name]
      when 'Say+Brother'
        SAY
      when "Ten+O'Clock+News"
        TEN
      when 'New+Television+Workshop'
        NTW
      when 'War+and+Peace+in+the+Nuclear+Age'
        NUKES
      end
    if target
      redirect_to target
    else
      render_404
    end
  end
    
  def redirect_series_mla
    # mla_number is available, so we could be more precise, with some work.
    target = 
      case params[:name]
      when 'ntw'
        NTW
      when 'saybrother'
        SAY
      when 'ton'
        TEN
      end
    if target
      redirect_to target
    else
      render_404
    end
  end
  
  def redirect_wapina_barcode
    # barcode is available, so we could be more precise, with some work.
    redirect_to NUKES
  end
  
end
