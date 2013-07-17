Openvault::Application.routes.draw do
  
  resources :custom_collections

  resources :collections, :only => [:index, :show]
  
  #match 'collections/:slug' => 'collections#show', slug: /[\w-]+/, as: 'collection_slug'
  
  match 'blog' => 'blog#index', :as => 'blog'

  root :to => "catalog#home"

  Blacklight.add_routes(self)
  HydraHead.add_routes(self)

  devise_for :users
  devise_for :admin_users, ActiveAdmin::Devise.config
  ActiveAdmin.routes(self)
  
  #mount Hydra::Collections::Engine => '/'

  #mount Sufia::Engine => '/'
  
end
