require 'spec_helper'
include Devise::TestHelpers
include Warden::Test::Helpers
Warden.test_mode!

feature 'Admin creates a user and that user can login' do
  before(:all) do
    @admin = create(:admin)
  end

  before(:each) do 
    login_as @admin
  end

  scenario 'admin can login and visit admin dashboard' do
    go_here "/admin"
    expect(page).to have_content('Welcome to ActiveAdmin')
  end

  scenario 'admin creates a new user', focus: true do
    go_here "/admin/users"
    click_link "New User"

    @user_attrs = attributes_for(:user)
    fill_in 'user_first_name', with: @user_attrs[:first_name]
    fill_in 'user_last_name', with: @user_attrs[:last_name]
    fill_in 'user_email', with: @user_attrs[:email]
    fill_in 'user_password', with: @user_attrs[:password]
    fill_in 'user_password_confirmation', with: @user_attrs[:password]
    check 'user_terms_and_conditions'
    select(@user_attrs[:role],from: "user_role")
    click_button "Create User"
    expect(page).to have_content("User was successfully created.")
    expect(User.where(email: @user_attrs[:email]).count).to eq 1
  end
end
