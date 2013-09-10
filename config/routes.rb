Openvault::Application.routes.draw do
  ActiveAdmin.routes(self)
  Blacklight.add_routes(self)
  HydraHead.add_routes(self)
  #mount Sufia::Engine => '/sufia'
  
  resources :custom_collections do
    get 'add_item'
  end
    #match 'custom_collections/:id/add_item/:asset_id' => 'custom_collections#add_item'
  #get ':controller/:action/:id/:asset_id'

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

  
  
  #general devise routes
  devise_for :users
  #for after you update your profile redirect to users#show instead of root_url (the devise default)
  devise_scope :users do
    get 'me', :to => 'users#show', :as => :user_root
  end
  devise_for :admin_users, ActiveAdmin::Devise.config
  
  #mount Hydra::Collections::Engine => '/'
  
  #use this for routes to scholars collections (i.e "/john-smith/my-awesome-collection-1")
  match '/scholar/:username/:custom_collection_slug' => 'custom_collections#show'
  
  #use this for user profile pages - have to override devise routes for user pages and add custom action
  match '/scholar/:username' => 'users#show', as: 'user_profile_page'
  match '/user/:username' => 'users#show', as: 'user_profile_page'
  match '/me' => 'users#show'
  match '/scholars' => 'users#scholars'
  
end
