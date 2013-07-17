require 'spec_helper'
include Warden::Test::Helpers
Warden.test_mode!

feature 'User tries to create a custom collection' do
  
  scenario 'when the user is not signed in' do
    visit new_custom_collection_path
    expect(page).to have_content("You are not authorized to access this page.")
  end
  
  scenario 'when the user is signed in but not a scholar' do
    submit_registration_form({email: "valid_#{Random.new.rand(10..100)}@me.com", password: '123456789', first_name: 'John', last_name: 'Smith', postal_code: '12345', country: 'United Kingdom', mla_updates: '1', terms_and_conditions: '1'})
    visit new_custom_collection_path
    expect(page).to have_content("You are not authorized to access this page.")
  end
  
  scenario 'when the user is signed in and IS a scholar' do
    #create new user
    create_user_assign_as_scholar
    in_browser(:one) do
      #go to page and try to fill out form
      create_custom_collection({name: "Testing Collection", summary: 'asdf asdf asdf asdf asdf'})
      #expect page to have the title of the collection on it
      expect(page).to have_content ('Name: Testing Collection')
    end
  end
  
end

feature 'User tries to edit a collection' do
  
  scenario 'when the user is not signed in' do
    create_user_assign_as_scholar
    in_browser(:one) do
      create_custom_collection({name: "Testing Collection blah blah blah", summary: 'asdf asdf asdf asdf asdf'})
    end
    in_browser(:two) do
      visit '/custom_collections/1/edit'
      expect(page).to have_content 'You are not authorized to access this page.'
    end
  end
  
  scenario 'when the user is signed in but not a scholar' do
    create_user_assign_as_scholar
    in_browser(:one) do
      create_custom_collection({name: "Testing Collection", summary: 'asdf asdf asdf asdf asdf'})
    end
    in_browser(:two) do
      submit_registration_form({email: "valid_#{Random.new.rand(10..100)}@me.com", password: '123456789', first_name: 'John', last_name: 'Smith', postal_code: '12345', country: 'United Kingdom', mla_updates: '1', terms_and_conditions: '1'})
      visit '/custom_collections/1/edit'
      expect(page).to have_content 'You are not authorized to access this page.'
    end
  end
  
  scenario 'when the user is signed in IS a scholar BUT did not create' do
    #first user1 and admin to make scholar user in b1 admin in b2
    create_user_assign_as_scholar
    in_browser(:one) do
      #create a collection in b1 by the user1
      create_custom_collection({name: "Testing Collection", summary: 'asdf asdf asdf asdf asdf'})
    end
    in_browser(:three) do
      #user2 signs up in b3
      submit_registration_form({email: "valider_#{Random.new.rand(10..100)}@me.com", password: '123456789', first_name: 'John2', last_name: 'Smith2', postal_code: '12345', country: 'United Kingdom', mla_updates: '1', terms_and_conditions: '1'})
    end
    in_browser(:two) do
      #admin makes user2 a scholar in b2
      assign_user_as_scholar({id: '2', create_admin: "false"})
    end
    in_browser(:three) do
      #user2 tries to edit colleciton of user1 in b3
      visit '/custom_collections/1/edit'
      expect(page).to have_content 'You are not authorized to access this page.'
    end
  end
  
  scenario 'when the user is signed in IS a scholar DID create' do
    create_user_assign_as_scholar
    in_browser(:one) do
      #create a collection in b1 by the user1
      create_custom_collection({name: "Testing Collection", summary: 'asdf asdf asdf asdf asdf'})
    end
    visit '/custom_collections/1/edit'
    fill_in 'custom_collection_name', with: 'Edited Testing Collection'
    click_button 'Update Custom collection'
    expect(page).to have_content 'Name: Edited Testing Collection'
  end
  
end


feature 'User tries to delete a collection' do
  
  scenario 'when the user is not signed in'
  
  scenario 'when the user is signed in but not a scholar'
  
  scenario 'when the user is signed in IS a scholar BUT did not create'
  
  scenario 'when the user is signed in IS a scholar DID create'
  
end
