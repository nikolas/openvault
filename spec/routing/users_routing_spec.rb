require "spec_helper"

describe UsersController do
  describe "routing" do
    
    it "/me routes to user #show" do
      get("/me").should route_to("users#show")
    end
    
    it "/user/:username routes to user #show" do
      get("/user/josh-wilcox").should route_to("users#show", :username => 'josh-wilcox')
    end
    
    it "/users/edit routes to devise/registrations#edit" do
      get("/users/edit").should route_to("registrations#edit")
    end
    
    it 'routes to devise/registrations#new' do
      get("/users/sign_up").should route_to("registrations#new")
    end
    
    it 'routes to devise/sessions#new' do
      get("/users/sign_in").should route_to("devise/sessions#new")
    end
    
  end
end
