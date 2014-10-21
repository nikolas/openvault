require 'spec_helper'

describe RedirectController, type: :request do

  describe '#redirect_series_name' do
    it 'redirects plain url' do
      get '/series/Say+Brother'
      expect(response).to redirect_to('/catalog/sbro-say-brother')
    end
    it 'redirects slash url' do
      get "/series/Ten+O'Clock+News/"
      expect(response).to redirect_to('/catalog/tocn-the-ten-o-clock-news')
    end
    it '404s, if nothing else' do
      get '/series/not+a+real+series'
      expect(response.code).to eq '404'
    end
  end
  
  describe '#redirect_series_mla' do
    it 'redirects plain url' do
      get '/saybrother/MLA000944'
      expect(response).to redirect_to('/catalog/sbro-say-brother')
    end
    it 'redirects long url' do
      get '/saybrother/MLA000927/index.html:'
      expect(response).to redirect_to('/catalog/sbro-say-brother')
    end
    it '404s, if nothing else' do
      get '/notaseries/MLA012345'
      expect(response.code).to eq '404'
    end
  end
  
  describe '#redirect_wapina_barcode' do
    it 'redirects expected' do
      get '/wapina/barcode49748nitze2_2/index.html'
      expect(response).to redirect_to('/catalog/wpna-wpna-war-and-peace-in-the-nuclear-age')
    end
    it 'redirects unexpected' do
      get '/wapina/the/spanish/inquisition'
      expect(response).to redirect_to('/catalog/wpna-wpna-war-and-peace-in-the-nuclear-age')
    end
  end
  
end
  