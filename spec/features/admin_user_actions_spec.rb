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

  scenario 'admin can login and visit admin dashboard', broken: true do
    go_here "/admin"
    expect(page).to have_content('Welcome to ActiveAdmin')
  end

  scenario 'admin creates a new user' do
    first = 'William'
    email = 'williamblake@gmail.com'
    password = 'wblake123456'
    
    go_here "/admin/users"
    click_link "New User"
    fill_in 'user_first_name', :with => first
    fill_in 'user_last_name', :with => 'Blake'
    fill_in 'user_email', :with => email
    fill_in 'user_password', :with => password
    fill_in 'user_password_confirmation', :with => password
    check 'user_terms_and_conditions'
    select("scholar",:from=> "user_role")
    click_button "Create User"
    expect(page).to have_content("User was successfully created.")
    click_link "Logout"
    click_link "Log In"
    fill_in 'user_email', :with => email
    fill_in 'user_password', :with => password
    click_button 'Sign in'
    expect(page).to have_content("Welcome back #{first}"), # TODO: when this test is working, kill the verbosity.
      'After capybara timeout, still not logged in: ajax calls still active: ' \
      + page.evaluate_script('jQuery.active').to_s \
      + '. Page content: ' + page.body
  end
end
