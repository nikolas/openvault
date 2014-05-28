require 'spec_helper'
# require 'helpers/test_helper'
include Warden::Test::Helpers
Warden.test_mode!

describe RegistrationsController do

    describe "PUT update..." do

    before :each do

      # Warden.test_reset!

      # Specify devise mappings. See:
      # https://github.com/plataformatec/devise/wiki/How-To%3a-Controllers-tests-with-Rails-3-%28and-rspec%29#mappings
      # https://github.com/plataformatec/devise#test-helpers
      # Also, this cannot be done in a `before(:all)`, as it does not recognize @request there.
      @request.env["devise.mapping"] = Devise.mappings[:user]

      # I tried creating the fake user in before(:all), but then you can't simulate signing in with sign_in helper.
      # No logical reason why. Just cant do it. Whatever. Sick of trying to figure out why. Moving on.
      @user = create(:user, :password => '123456789')
      @user.save

      # sign in as the fake user
      sign_in @user

      # This test is here to catch failures for Devise to log the user in should it happen again due to whatever
      # black magic is going on behind the curtain.
      subject.current_user.should == @user
    end

    it 'redirects to "/me", sets @user instance variable, and does not require a password when updating any field except for email' do

      # Grab some test data to update with. We want:
      #   unchanged `email`
      #   no `password`
      #   no `password_confirmation`
      #   no `current_password`
      @user_attrs = attributes_for(:user, email: nil, password: nil, password_confirmation: nil)
      @user_attrs[:email] = @user.email

      
      # make the request
      put :update, id: @user.to_param, user: @user_attrs

      # check response redirect location
      response.should redirect_to "/me"
      # ensure a `user` instance variable was set
      assigns(:user).should_not be_nil
    end

  

    it 'redirects to "/me" and sets @user instance variable when trying to update `email` and `current_password` is valid' do

      # Grab some test data to update with. We want:
      #   changed `email`
      #   no `password`
      #   no `password_confirmation`
      #   valid `current_password`
      @user_attrs = attributes_for(:user, password: nil, password_confirmation: nil)
      @user_attrs[:current_password] = @user.password
      
      # Make the request.
      put :update, id: @user.to_param, user: @user_attrs

      # Should have worked, and redricted to "/me".
      response.should redirect_to "/me"

      # Should assign @user instance var.
      assigns(:user).should_not be_nil
    end

    it 'redirects back to `edit` page and sets errors when trying to update `email` and `current_password` is invalid' do

      # Grab some test data to update with. We want:
      #   changed `email`
      #   no `password`
      #   no `password_confirmation`
      #   invalid `current_password`
      @user_attrs = attributes_for(:user, password: nil, password_confirmation: nil)
      @user_attrs[:current_password] = 'abc'
      
      # make the request
      put :update, id: @user.to_param, user: @user_attrs

      # Should re-render the `edit` page.
      response.should render_template "edit"

      # Should set some errors
      assigns(:user).errors.should_not be_empty
    end

    it 'redirects back to `edit` page with errors when trying to update `email` and `current_password` is blank' do
      # Grab some test data to update with. We want:
      #   changed `email`
      #   no `password`
      #   no `password_confirmation`
      #   no `current_password` (is not returned by attributes_for, no action required)
      @user_attrs = attributes_for(:user, password: nil, password_confirmation: nil)

      # make the request
      put :update, id: @user.to_param, user: @user_attrs

      # Should re-render the `edit` page.
      response.should render_template "edit"

      # Should set some errors
      assigns(:user).errors.should_not be_empty
    end


    it 'redirects to "/me" and sets @user instance var when trying to update `password`, `current_password` is valid, and when `password` matches `password_confirmation`.' do
      # Grab some test data to update with. We want:
      #   changed `password`
      #   matching `password_confirmation`
      #   valid `current_password`
      new_password = attributes_for(:user)[:password]
      @user_attrs = {
        :current_password => @user.password,
        :password => new_password,
        :password_confirmation => new_password
      }
      
      # Make the request.
      put :update, id: @user.to_param, user: @user_attrs

      # Should have worked, and redricted to "/me".
      response.should redirect_to "/me"

      # Should assign @user instance var.
      assigns(:user).should_not be_nil
    end

    it 're-renders `edit` page with errors when trying to update `password`, and `password` matches `password_confirmation`, but `current_password` is invalid' do
      # Grab some test data to update with. We want:
      #   changed `password`
      #   matching `password_confirmation`
      #   invalid `current_password`
      new_password = attributes_for(:user)[:password]
      @user_attrs = {
        :current_password => "this is the wrong password",
        :password => new_password,
        :password_confirmation => new_password
      }
      
      # Make the request.
      put :update, id: @user.to_param, user: @user_attrs

      # Should have worked, and redricted to "/me".
      response.should_not redirect_to "/me"

      # Should re-render the `edit` page.
      response.should render_template "edit"

      # Should set some errors
      assigns(:user).errors.should_not be_empty
    end


    it 're-renders `edit` page with errors when trying to edit `password`, where `current_password` is valid, but `password` does not match `password_confirmation`' do
      # Grab some test data to update with. We want:
      #   changed `password`
      #   non-matching `password_confirmation`
      #   valid `current_password`
      new_password = attributes_for(:user)[:password]
      @user_attrs = {
        :current_password => @user.password,
        :password => new_password,
        :password_confirmation => "this is the wrong password"
      }
      
      # Make the request.
      put :update, id: @user.to_param, user: @user_attrs

      # Should have worked, and redricted to "/me".
      response.should_not redirect_to "/me"

      # Should re-render the `edit` page.
      response.should render_template "edit"

      # Should set some errors
      assigns(:user).errors.should_not be_empty
    end
    
  end

end