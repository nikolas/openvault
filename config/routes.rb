Openvault::Application.routes.draw do
  devise_for :users, :controllers => {:registrations => "registrations"}
  
  
  # ad-hoc redirects

  # Collection moved:
  get 'catalog/tocn-the-ten-o-clock-news', to: redirect('http://bostonlocaltv.org/wgbh')
  get 'catalog/roll-rock-and-roll', to: 'override#show_rock_and_roll'
  get 'catalog/wpna-wpna-war-and-peace-in-the-nuclear-age', to: 'override#show_wpna'
  
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

  get 'custom_collections/new/:asset_id/:kind' => 'custom_collections#new'

  resources :custom_collections do
    get 'add_item'
    get 'remove_item'
  end

  root :to => "catalog#home"

  get 'collections/:file', to: redirect("/catalog/%{file}"), constraints: { file: /
      advocates-advocates |
      prpe-press-and-the-people |
      roll-rock-and-roll |
      sbro-say-brother |
      tocn-the-ten-o-clock-news |
      vietnam-the-vietnam-collection |
      wpna-wpna-war-and-peace-in-the-nuclear-age
    /x }
  
  resources :catalog, :only => [:index, :show, :update], :constraints => { :id => /([A-Za-z0-9]|:|-|\.)*([A-Za-z0-9]|:|-){7}/ } do
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
  get '/blog/*path', to: redirect('http://blog.openvault.wgbh.org/%{path}')
  
  # ad-hoc redirects, based on web-master tools.
  get '/series/:name', to: 'redirect#redirect_series_name'
  get '/:name/:mla_number(/*path)', to: 'redirect#redirect_series_mla', constraints: { mla_number: /MLA\d+/ }
  get '/wapina/:barcode(/*path)', to: 'redirect#redirect_wapina_barcode'
  
  get '/*path', to: 'override#show', constraints: { :path => /[a-z\/-]+/ }
end
