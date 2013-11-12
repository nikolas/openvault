require 'spec_helper'
require 'helpers/test_helper'
include Warden::Test::Helpers
Warden.test_mode!

feature 'Visitor signs up' do
  scenario 'with valid info in all fields' do
    submit_registration_form({email: "valid_#{Random.new.rand(10..100)}@me.com", password: '123456789', first_name: 'John', last_name: 'Smith', country: 'United Kingdom', mla_updates: '1', terms_and_conditions: '1'})
    expect(page).to have_content('Log Out')
  end

  scenario 'with invalid email' do
    Warden.test_reset!
    visit destroy_user_session_url
    submit_registration_form({email: "valid_#{Random.new.rand(10..100)}", password: '123456789', first_name: 'John', last_name: 'Smith', country: 'United Kingdom', mla_updates: '1', terms_and_conditions: '1'})
    expect(page).to have_content('Email is invalid')
  end

  scenario 'with blank password' do
    Warden.test_reset!
    visit destroy_user_session_url
    submit_registration_form({email: "valid_#{Random.new.rand(10..100)}@me.com", password: '', first_name: 'John', last_name: 'Smith', country: 'United Kingdom', mla_updates: '1', terms_and_conditions: '1'})
    expect(page).to have_content('Password can\'t be blank')
  end 
  
  scenario 'with blank name' do
    Warden.test_reset!
    visit destroy_user_session_url
    submit_registration_form({email: "valid_#{Random.new.rand(10..100)}@me.com", password: '123456789', first_name: '', last_name: 'Smith', country: 'United Kingdom', mla_updates: '1', terms_and_conditions: '1'})
    expect(page).to have_content('First name can\'t be blank')
  end
  
  scenario 'with blank last name' do
    Warden.test_reset!
    visit destroy_user_session_url
    submit_registration_form({email: "valid_#{Random.new.rand(10..100)}@me.com", password: '123456789', first_name: 'John', last_name: '', country: 'United Kingdom', mla_updates: '1', terms_and_conditions: '1'})
    expect(page).to have_content('Last name can\'t be blank')
  end
  
  scenario 'user can login after already signing up' do
    Warden.test_reset!
    visit destroy_user_session_url
    
    user = FactoryGirl.create(:user)
    
    submit_login_form({email: user.email, password: user.password})
    expect(page).to have_content('Log Out')
  end
  
end

feature "Users wants to edit their profile" do
  before :each do 
    Warden.test_reset!
    visit destroy_user_session_url
    @user = create(:user, :password => '123456789')
  end
  scenario "by changing their name" do
    login_as(@user, :scope => :user, :run_callbacks => false)
    visit '/users/edit'
    fill_in 'user_first_name', with: "Bobby"
    fill_in 'user_last_name', with: "Smitherson"
    fill_in 'user_current_password', with: '123456789'
    click_button 'Save Profile'
    expect(page).to have_content("Edit profile")
  end
  
  scenario "by changing their email" do
    login_as(@user, :scope => :user, :run_callbacks => false)
    visit '/users/edit'
    fill_in 'user_email', with: "valid_valid_#{Random.new.rand(10..100)}@me.com"
    fill_in 'user_current_password', with: '123456789'
    click_button 'Save Profile'
    expect(page).to have_content("Edit profile")
  end
  
  scenario "by changing their location" do
    login_as(@user, :scope => :user, :run_callbacks => false)
    visit '/users/edit'
    select 'France', from: 'user_country'
    fill_in 'user_current_password', with: '123456789'
    click_button 'Save Profile'
    expect(page).to have_content("Edit profile")
  end

end
