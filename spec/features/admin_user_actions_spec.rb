require 'spec_helper'
include Devise::TestHelpers
include Warden::Test::Helpers
Warden.test_mode!

feature 'Admin creates a user and that user can login' do
	before(:each) do 
		login_as_admin
	end
  scenario 'admin can login and visit admin dashboard', broken: true do
  	go_here "/admin"
    expect(page).to have_content('Welcome to ActiveAdmin')
  end

  scenario 'admin creates a new user', broken: true do 
  	go_here "/admin/users"
  	click_link "New User"
  	fill_in 'user_first_name', :with => 'William'
  	fill_in 'user_last_name', :with => 'Blake'
  	fill_in 'user_email', :with => 'williamblake@gmail.com'
  	fill_in 'user_password', :with => "wblake123456"
  	fill_in 'user_password_confirmation', :with => 'wblake123456'
  	check 'user_terms_and_conditions'
  	select("scholar",:from=> "user_role")
  	click_button "Create User"
  	expect(page).to have_content("User was successfully created.")
  	click_link "Logout"
  	click_link "Log In"
  	fill_in 'user_email', :with => 'williamblake@gmail.com'
  	fill_in 'user_password', :with => 'wblake123456'
  	click_button 'Sign in'
  	expect(page).to have_content("Welcome back William")
  end
end