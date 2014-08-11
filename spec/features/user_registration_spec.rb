require 'spec_helper'

feature 'Visitor signs up' do
  let(:user) { FactoryGirl.create(:user) }
  before(:each) do
    visit destroy_user_session_url
  end

  scenario 'with valid info in all fields' do
    submit_registration_form({email: "valid_#{Random.new.rand(10..100)}@me.com", password: '123456789', first_name: 'John', last_name: 'Smith', country: 'United Kingdom', mla_updates: '1', terms_and_conditions: '1'})
    expect(page).to have_content('Log Out')
  end

  scenario 'with invalid email' do
    submit_registration_form({email: "valid_#{Random.new.rand(10..100)}", password: '123456789', first_name: 'John', last_name: 'Smith', country: 'United Kingdom', mla_updates: '1', terms_and_conditions: '1'})
    expect(page).to have_content('Email is invalid')
  end

  scenario 'no terms and conditions' do
    submit_registration_form({email: "valid_#{Random.new.rand(10..100)}", password: '123456789', first_name: 'John', last_name: 'Smith', country: 'United Kingdom', mla_updates: '1'})
    expect(page).to have_content('Terms and conditions must be agreed to')
  end

  scenario 'with blank password' do
    submit_registration_form({email: "valid_#{Random.new.rand(10..100)}@me.com", password: '', first_name: 'John', last_name: 'Smith', country: 'United Kingdom', mla_updates: '1', terms_and_conditions: '1'})
    expect(page).to have_content('Password can\'t be blank')
  end

  scenario 'with blank name' do
    submit_registration_form({email: "valid_#{Random.new.rand(10..100)}@me.com", password: '123456789', first_name: '', last_name: 'Smith', country: 'United Kingdom', mla_updates: '1', terms_and_conditions: '1'})
    expect(page).to have_content('First name can\'t be blank')
  end

  scenario 'with blank last name' do
    submit_registration_form({email: "valid_#{Random.new.rand(10..100)}@me.com", password: '123456789', first_name: 'John', last_name: '', country: 'United Kingdom', mla_updates: '1', terms_and_conditions: '1'})
    expect(page).to have_content('Last name can\'t be blank')
  end

  scenario 'user can login after already signing up' do
    submit_login_form({email: user.email, password: user.password})
    expect(page).to have_content('Log Out')
  end
end
