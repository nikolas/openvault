require 'spec_helper'
require 'helpers/test_helper'
include Warden::Test::Helpers
Warden.test_mode!

feature 'Visitor signs up' do
  scenario 'with valid info in all fields' do
    submit_registration_form({email: "valid_#{Random.new.rand(10..100)}@me.com", password: '123456789', first_name: 'John', last_name: 'Smith', postal_code: '12345', country: 'United Kingdom', mla_updates: '1', terms_and_conditions: '1'})
    expect(page).to have_content('Log Out')
  end

  scenario 'with invalid email' do
    Capybara.reset_sessions!
    visit destroy_user_session_url
    #submit_registration_form "valid_#{Random.new.rand(10..100)}", '123456789', 'John', 'Smith', '12345', 'United Kingdom', '1', '1'
    submit_registration_form({email: "valid_#{Random.new.rand(10..100)}", password: '123456789', first_name: 'John', last_name: 'Smith', postal_code: '12345', country: 'United Kingdom', mla_updates: '1', terms_and_conditions: '1'})
    expect(page).to have_content('Log In')
  end

  scenario 'with blank password' do
    Capybara.reset_sessions!
    visit destroy_user_session_url
    #submit_registration_form "valid_#{Random.new.rand(10..100)}@example.com", '', 'John', 'Smith', '12345', 'United Kingdom', '1', '1'
    submit_registration_form({email: "valid_#{Random.new.rand(10..100)}@me.com", password: '', first_name: 'John', last_name: 'Smith', postal_code: '12345', country: 'United Kingdom', mla_updates: '1', terms_and_conditions: '1'})
    expect(page).to have_content('Log In')
  end 
  
  scenario 'with blank name' do
    Capybara.reset_sessions!
    visit destroy_user_session_url
    #submit_registration_form "valid_#{Random.new.rand(10..100)}@example.com", '123456789', '', 'Smith', '12345', 'United Kingdom', '1', '1'
    submit_registration_form({email: "valid_#{Random.new.rand(10..100)}@me.com", password: '123456789', first_name: '', last_name: 'Smith', postal_code: '12345', country: 'United Kingdom', mla_updates: '1', terms_and_conditions: '1'})
    expect(page).to have_content('Log In')
  end
  
  scenario 'with blank last name' do
    Capybara.reset_sessions!
    visit destroy_user_session_url
    #submit_registration_form "valid_#{Random.new.rand(10..100)}@example.com", '123456789', 'john', '', '12345', 'United Kingdom', '1', '1'
    submit_registration_form({email: "valid_#{Random.new.rand(10..100)}@me.com", password: '123456789', first_name: 'John', last_name: '', postal_code: '12345', country: 'United Kingdom', mla_updates: '1', terms_and_conditions: '1'})
    expect(page).to have_content('Log In')
  end
  
  scenario 'with blank zip code' do
    Capybara.reset_sessions!
    visit destroy_user_session_url
    #submit_registration_form "valid_#{Random.new.rand(10..100)}@example.com", '123456789', 'john', 'smith', '', 'United Kingdom', '1', '1'
    submit_registration_form({email: "valid_#{Random.new.rand(10..100)}@me.com", password: '123456789', first_name: 'John', last_name: 'Smith', postal_code: '', country: 'United Kingdom', mla_updates: '1', terms_and_conditions: '1'})
    expect(page).to have_content('Log In')
  end 
  
  scenario 'with terms not checked' do
    Capybara.reset_sessions!
    visit destroy_user_session_url
    #submit_registration_form "valid_#{Random.new.rand(10..100)}@example.com", '123456789', 'john', 'smith', '12345', 'United Kingdom', '1', nil
    submit_registration_form({email: "valid_#{Random.new.rand(10..100)}@me.com", password: '123456789', first_name: 'John', last_name: 'Smith', postal_code: '12345', country: 'United Kingdom', mla_updates: '1'})
    expect(page).to have_content('Log In')
  end
  
  scenario 'user can login after already signing up' do
    Capybara.reset_sessions!
    visit destroy_user_session_url
    
    user = FactoryGirl.create(:user)
    
    submit_login_form({email: user.email, password: user.password})
    expect(page).to have_content('Log Out')
  end
  
end

feature "Users wants to edit their profile" do
  before :each do 
    submit_registration_form({email: "valid_#{Random.new.rand(10..100)}@me.com", password: '123456789', first_name: 'John', last_name: 'Smith', postal_code: '12345', country: 'United Kingdom', mla_updates: '1', terms_and_conditions: '1'})
  end
  scenario "by changing their name" do
    visit '/users/edit'
    fill_in 'user_first_name', with: "Bobby"
    fill_in 'user_last_name', with: "Smitherson"
    fill_in 'user_current_password', with: '123456789'
    click_button 'Update profile'
    expect(page).to have_content("Edit profile")
  end
  
  scenario "by changing their email" do
    visit '/users/edit'
    fill_in 'user_email', with: "valid_valid_#{Random.new.rand(10..100)}@me.com"
    fill_in 'user_current_password', with: '123456789'
    click_button 'Update profile'
    expect(page).to have_content("Edit profile")
  end
  
  scenario "by changing their location" do
    visit '/users/edit'
    fill_in 'user_postal_code', with: "32145-1234"
    select 'France', from: 'user_country'
    fill_in 'user_current_password', with: '123456789'
    click_button 'Update profile'
    expect(page).to have_content("Edit profile")
  end
  
  scenario "by changing their password" do
    visit '/users/edit'
    click_link 'Change Password'
    fill_in 'user_password', with: '987654321'
    fill_in 'user_password_confirmation', with: '987654321'
    fill_in 'user_current_password', with: '123456789'
    click_button 'Update profile'
    expect(page).to have_content("Edit profile")
  end
  
  #bundling delete in this feature as it only one scenario
  scenario "by deleting their profile entirely" do
    visit '/users/edit'
    click_button 'Cancel my account'
    #confirm JS alert
    page.driver.browser.accept_js_confirms
    
    expect(page).to have_content("Log In | Register")
  end

end
