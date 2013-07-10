require 'spec_helper'
include Warden::Test::Helpers
Warden.test_mode!
feature 'Visitor signs up' do
  scenario 'with valid info in all fields' do
    submit_registration_form "valid_#{Random.new.rand(10..100)}@example.com", '123456789', 'John', 'Smith', '12345', 'United Kingdom', '1', '1'
    expect(page).to have_content('Log Out')
  end

  scenario 'with invalid email' do
    Capybara.reset_sessions!
        visit destroy_user_session_url
    submit_registration_form "valid_#{Random.new.rand(10..100)}", '123456789', 'John', 'Smith', '12345', 'United Kingdom', '1', '1'

    expect(page).to have_content('Log In')
  end

  scenario 'with blank password' do
    Capybara.reset_sessions!
        visit destroy_user_session_url
    submit_registration_form "valid_#{Random.new.rand(10..100)}@example.com", '', 'John', 'Smith', '12345', 'United Kingdom', '1', '1'

    expect(page).to have_content('Log In')
  end 
  
  scenario 'with blank name' do
    Capybara.reset_sessions!
        visit destroy_user_session_url
    submit_registration_form "valid_#{Random.new.rand(10..100)}@example.com", '123456789', '', 'Smith', '12345', 'United Kingdom', '1', '1'

    expect(page).to have_content('Log In')
  end
  
  scenario 'with blank last name' do
    Capybara.reset_sessions!
        visit destroy_user_session_url
    submit_registration_form "valid_#{Random.new.rand(10..100)}@example.com", '123456789', 'john', '', '12345', 'United Kingdom', '1', '1'

    expect(page).to have_content('Log In')
  end
  
  scenario 'with blank zip code' do
    Capybara.reset_sessions!
        visit destroy_user_session_url
    submit_registration_form "valid_#{Random.new.rand(10..100)}@example.com", '123456789', 'john', 'smith', '', 'United Kingdom', '1', '1'

    expect(page).to have_content('Log In')
  end 
  
  scenario 'with terms not checked' do
    Capybara.reset_sessions!
    visit destroy_user_session_url
    submit_registration_form "valid_#{Random.new.rand(10..100)}@example.com", '123456789', 'john', 'smith', '12345', 'United Kingdom', '1', nil

    expect(page).to have_content('Log In')
  end
  
  scenario 'user can login after already signing up' do
    Capybara.reset_sessions!
    visit destroy_user_session_url
    
    user = FactoryGirl.create(:user)
    
    submit_login_form user.email, user.password
    expect(page).to have_content('Log Out')
  end

  def submit_login_form(email, password)
    go_here '/users/sign_in'
    fill_in 'user_email', with: email unless email.nil?
    fill_in 'user_password', with: password unless password.nil?
    check 'user_remember_me'
    click_button 'Log in'
  end
  
  def submit_registration_form (email, password, first_name, last_name, postal_code, country, mla_updates, terms_and_conditions)
    go_here '/users/sign_up'
    fill_in 'user_email', with: email unless email.nil?
    fill_in 'user_password', with: password unless password.nil?
    fill_in 'user_password_confirmation', with: password unless password.nil?
    fill_in 'user_first_name', with: first_name unless first_name.nil?
    fill_in 'user_last_name', with: last_name unless last_name.nil?
    fill_in 'user_postal_code', with: postal_code unless postal_code.nil?
    check 'user_terms_and_conditions' unless terms_and_conditions.nil?
    find('#user_terms_and_conditions').set(true) unless terms_and_conditions.nil?
    select country, from: 'user_country' unless country.nil?
    click_button 'Register'
  end
  
end