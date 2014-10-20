require 'spec_helper'

describe RedirectController, type: :request do

  describe "#redirect_series_name" do
    
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
  
end
  