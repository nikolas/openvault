Openvault::Application.routes.draw do
  
  resources :collections, :only => [:index, :show]
  
  match 'blog' => 'blog#index', :as => 'blog'

  root :to => "catalog#home"

  Blacklight.add_routes(self)
  HydraHead.add_routes(self)

  devise_for :users
  devise_for :admin_users, ActiveAdmin::Devise.config
  ActiveAdmin.routes(self)

  #mount Sufia::Engine => '/'
  
end
