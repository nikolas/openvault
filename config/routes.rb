Openvault::Application.routes.draw do
  devise_for :users, :controllers => {:registrations => "registrations"}
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
      get 'cite'
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
  
  get '/blog/*path', to: redirect('http://blog.openvault.wgbh.org/%{path}')
  
  # ad-hoc redirects, based on web-master tools.
  get '/series/:name', to: 'redirect#redirect_series_name'
  get '/:name/:mla_number(/*path)', to: 'redirect#redirect_series_mla', constraints: { mla_number: /MLA\d+/ }
  get '/wapina/:barcode(/*path)', to: 'redirect#redirect_wapina_barcode'
  
  get '/*path', to: 'override#show', constraints: { :path => /[a-z\/-]+/ }
end
