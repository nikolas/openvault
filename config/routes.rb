Openvault::Application.routes.draw do
  
  mount Sufia::Engine => '/sufia'
  
  resources :custom_collections

  resources :collections, :only => [:index, :show]
  
  match 'collection/:slug' => 'collections#show', slug: /[\w-]+/, as: 'collection_slug'
  
  match 'blog' => 'blog#index', :as => 'blog'

  root :to => "catalog#home"

  Blacklight.add_routes(self)
  HydraHead.add_routes(self)
  
  #general devise routes
  devise_for :users
  #for after you update your profile redirect to users#show instead of root_url (the devise default)
  devise_scope :users do
    get 'me', :to => 'users#show', :as => :user_root
  end
  devise_for :admin_users, ActiveAdmin::Devise.config
  ActiveAdmin.routes(self)
  
  #mount Hydra::Collections::Engine => '/'
  
  #use this for routes to scholars collections (i.e "/john-smith/my-awesome-collection-1")
  match '/scholar/:username/:custom_collection_slug' => 'custom_collections#show'
  
  #use this for user profile pages - have to override devise routes for user pages and add custom action
  match '/scholar/:username' => 'users#show', as: 'user_profile_page'
  match '/me' => 'users#show'
  
end
