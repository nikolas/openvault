Openvault::Application.routes.draw do
  ActiveAdmin.routes(self)
  Blacklight.add_routes(self)
  HydraHead.add_routes(self)
  #mount Sufia::Engine => '/sufia'
  
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
  
  
  get 'series/:id', to: 'series#show', id: /([A-Za-z0-9]|:|-|\.)*([A-Za-z0-9]|:|-){7}/
  get 'series/:id/print', to: 'series#print', id: /([A-Za-z0-9]|:|-|\.)*([A-Za-z0-9]|:|-){7}/
  get 'programs/:id', to: 'programs#show', id: /([A-Za-z0-9]|:|-|\.)*([A-Za-z0-9]|:|-){7}/
  get 'programs/:id/print', to: 'programs#print', id: /([A-Za-z0-9]|:|-|\.)*([A-Za-z0-9]|:|-){7}/
  get 'video/:id', to: 'videos#show', id: /([A-Za-z0-9]|:|-|\.)*([A-Za-z0-9]|:|-){7}/
  get 'video/:id/print', to: 'videos#print', id: /([A-Za-z0-9]|:|-|\.)*([A-Za-z0-9]|:|-){7}/
  get 'audio/:id', to: 'audios#show', id: /([A-Za-z0-9]|:|-|\.)*([A-Za-z0-9]|:|-){7}/

  
  
  #general devise routes. Use custom RegistrationsController
  devise_for :users, :controllers => {registrations: "registrations"}

  #for after you update your profile redirect to users#show instead of root_url (the devise default)
  devise_scope :users do
    get 'me', :to => 'users#show', :as => :user_root
  end

  devise_for :admin_users, ActiveAdmin::Devise.config
  
  #mount Hydra::Collections::Engine => '/'
  
  #use this for routes to scholars collections (i.e "/john-smith/my-awesome-collection-1")
  match '/scholar/:username/:custom_collection_slug' => 'custom_collections#show'
  
  #use this for user profile pages - have to override devise routes for user pages and add custom action
  # match '/scholar/:username' => 'users#show', as: :user
  # match '/user/:id' => 'users#show', as: :user
  match '/user/:username' => 'users#show', as: :user
  match '/me' => 'users#show'
  match '/scholars' => 'users#scholars'
  
end
