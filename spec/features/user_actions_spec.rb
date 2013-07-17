require 'spec_helper'
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