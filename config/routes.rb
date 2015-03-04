Openvault::Application.routes.draw do
  devise_for :users, :controllers => {:registrations => "registrations"}

  # Routing for exhibits (a.k.a. collections -- but we don't call them that anymore)

  get 'collections', to: 'exhibits#index'

  get 'catalog/tocn-the-ten-o-clock-news', to: redirect('http://bostonlocaltv.org/wgbh')

  get 'catalog/44ffa1-rock-and-roll', to: 'exhibits#rock_and_roll'
  get 'catalog/roll-rock-and-roll', to: 'exhibits#rock_and_roll'
  get 'collections/roll-rock-and-roll', to: 'exhibits#rock_and_roll'

  get 'catalog/wpna-wpna-war-and-peace-in-the-nuclear-age', to: 'exhibits#wpna'
  get 'collections/wpna-wpna-war-and-peace-in-the-nuclear-age', to: 'exhibits#wpna'
  get 'collections/war-and-peace-in-the-nuclear-age', to: 'exhibits#wpna'

  get 'catalog/vietnam-the-vietnam-collection', to: 'exhibits#vietnam'
  get 'collections/vietnam-the-vietnam-collection', to: 'exhibits#vietnam'

  get 'catalog/prpe-press-and-the-people', to: 'exhibits#press_and_people'
  get 'collections/prpe-press-and-the-people', to: 'exhibits#press_and_people'

  get 'catalog/march-march-on-washington', to: 'exhibits#march_on_washington'
  get 'collections/march-march-on-washington', to: 'exhibits#march_on_washington'

  get 'catalog/sbro-say-brother', to: 'exhibits#say_brother'
  get 'collections/sbro-say-brother', to: 'exhibits#say_brother'

  get 'catalog/vault-from-the-vault', to: 'exhibits#from_the_vault'
  get 'collections/vault-from-the-vault', to: 'exhibits#from_the_vault'
  get 'catalog/from-the-vault', to: 'exhibits#from_the_vault'
  get 'collections/from-the-vault', to: 'exhibits#from_the_vault'

  get 'collections/advocates-advocates', to: 'exhibits#advocates'
  get 'catalog/advocates-advocates', to: 'exhibits#advocates'
  get 'catalog/advocates', to: 'exhibits#advocates'
  
  get ':lists_or_blog/rock-and-roll-interview-list', to: redirect('/catalog/roll-rock-and-roll')
  get ':lists_or_blog/wpna-interview-list', to: redirect('/catalog/wpna-wpna-war-and-peace-in-the-nuclear-age')
  
  # WebmasterTools identified these inbound links:
  get 'faq.html', to: redirect('/help')
  get 'about_mla.html', to: redirect('/about')
  get '7b7ae3-steve-jobs-interview.html', to: redirect('/catalog/7b7ae3-steve-jobs-interview')
  get 'access_policy.html', to: redirect('/visiting-the-archives')
  get 'advanced_search', to: redirect('/catalog') # TODO
  # get 'user_util_links', to: redirect(????)
  get 'contact_us.html', to: redirect('/contact-us')
  get 'terms_and_conditions.html', to: redirect('/terms-and-conditions')
  get 'privacy_policy.html', to: redirect('/privacy-policy')
  
  ActiveAdmin.routes(self)
  Blacklight.add_routes(self)
  HydraHead.add_routes(self)
  #mount Sufia::Engine => '/sufia'
  
  get 'oai' => 'oai#index'

  get 'custom_collections/new/:asset_id/:kind' => 'custom_collections#new'

  resources :custom_collections do
    get 'add_item'
    get 'remove_item'
  end

  root :to => "catalog#home"
  
  resources :catalog, :only => [:index, :show], :constraints => { :id => /([A-Za-z0-9]|:|-|\.)*([A-Za-z0-9]|:|-){7}/ } do
    member do
      get 'print'
      get 'image'
      get 'embed'
    end
    resource :tags
  end

  resources :digitizations
  resources :transcriptions

  resources :sponsorships do
    member do
      put 'confirm'
      put 'unconfirm'
    end
  end

  get 'series', as: 'browse_series', to: 'series#browse_by_title'
  get 'program', as: 'browse_programs', to: 'programs#browse_by_year'

  #general devise routes. Use custom RegistrationsController
  devise_for :users, :controllers => {registrations: "registrations"}

  #for after you update your profile redirect to users#show instead of root_url (the devise default)
  devise_scope :users do
    get 'me', :to => 'users#show_profile', :as => :user_root
  end

  #mount Hydra::Collections::Engine => '/'

  #use this for user profile pages - have to override devise routes for user pages and add custom action
  get '/user/:username', to: 'users#show', as: :user
  get '/scholar/:username', to: 'users#scholar', as: :scholar
  get '/scholars', to: 'users#scholars'
  
  # Old blog URLs:
  get "/blog/about/", to: redirect("/about")
  get "/blog/about/media-production-organizational-tools/", to: redirect("/media-production-organizational-tools")
  get "/blog/media-production-organizational-tools/", to: redirect("/media-production-organizational-tools")
  get "/blog/category/march-on-washington/", to: redirect("/collections/march-march-on-washington")
  get "/blog/march-on-washington/", to: redirect("/collections/march-march-on-washington")
  get "/blog/contact-us/", to: redirect("/contact-us")
  get "/blog/credits-:name/", to: redirect("/credits/credits-%{name}")
  get "/blog/credits/", to: redirect("/credits/credits")
  get "/blog/help/", to: redirect("/help")
  get "/blog/privacy-policy/", to: redirect("/privacy-policy")
  get "/blog/series-list/", to: redirect("/series")
  get "/blog/terms-and-conditions/", to: redirect("/terms-and-conditions")
  get "/blog/visiting-the-archives/", to: redirect("/visiting-the-archives")
  # everything else:
  get '/blog/*path', to: redirect { |params, request| 
    # With normal % templating, the path was being URL escaped.
    "http://blog.openvault.wgbh.org/#{params[:path]}" 
  }
  
  # ad-hoc redirects, based on web-master tools.
  get '/series/:name', to: 'redirect#redirect_series_name'
  get '/:name/:mla_number(/*path)', to: 'redirect#redirect_series_mla', constraints: { mla_number: /MLA\d+/ }
  get '/wapina/:barcode(/*path)', to: 'redirect#redirect_wapina_barcode'
  
  get '/*path', to: 'override#show', constraints: lambda { |req| 
    path = req.params['path']
    path.match(/^[a-z\/-]+$/) && !path.match(/^rails/) 
  }
end
