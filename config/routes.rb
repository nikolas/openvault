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

  resources :collections, :only => [:index, :show]
  match 'collection/:slug' => 'collections#show', slug: /[\w-]+/, as: 'collection_slug'

  match 'blog' => 'blog#index', :as => 'blog'

  root :to => "catalog#home"

  resources :catalog, :only => [:index, :show, :update], :constraints => { :id => /([A-Za-z0-9]|:|-|\.)*([A-Za-z0-9]|:|-){7}/ } do
    member do
      get 'cite'
      get 'print'
      get 'image'
      get 'embed'
    end
    resources :comments, :constraints => { :id => /[0-9]+/ }
    resource :tags
  end

  get 'series/:id', as: 'series', to: 'series#show'
  get 'series/:id/print', as: 'print_series', to: 'series#print'
  get 'series', as: 'browse_series', to: 'series#browse_by_title'

  get 'program/:id', as: 'program', to: 'programs#show'
  get 'program/:id/print', as: 'print_program', to: 'programs#print'
  get 'video/:id', as: 'video', to: 'videos#show'
  get 'video/:id/print', as: 'print_video', to: 'videos#print'
  get 'audio/:id', as: 'audio', to: 'audios#show'

  #general devise routes. Use custom RegistrationsController
  devise_for :users, :controllers => {registrations: "registrations"}

  #for after you update your profile redirect to users#show instead of root_url (the devise default)
  devise_scope :users do
    get 'me', :to => 'users#show', :as => :user_root
  end

  #mount Hydra::Collections::Engine => '/'

  #use this for user profile pages - have to override devise routes for user pages and add custom action
  # match '/scholar/:username' => 'users#show', as: :user
  # match '/user/:id' => 'users#show', as: :user
  get '/user/:username', to: 'users#show', as: :user
  get '/scholar/:username', to: 'users#scholar'
  get '/me', to: 'users#show'
  get '/scholars', to: 'users#scholars'
end
