require 'spec_helper'
require 'helpers/test_helper'
include Warden::Test::Helpers
Warden.test_mode!

#Many of these will need to change as the UI changes
feature 'User tries to create a custom collection' do
  
  scenario 'when the user is not signed in' do
    Capybara.reset_sessions!
    visit new_custom_collection_path
    expect(page).to have_content("You are not authorized to access this page.")
  end
  
  scenario 'when the user is signed in but not a scholar' do
    Capybara.reset_sessions!
    submit_registration_form({email: "valid_#{Random.new.rand(10..100)}@me.com", password: '123456789', first_name: 'John', last_name: 'Smith', postal_code: '12345', country: 'United Kingdom', mla_updates: '1', terms_and_conditions: '1'})
    visit new_custom_collection_path
    expect(page).to have_content("You are not authorized to access this page.")
  end
  
  scenario 'when the user is signed in and IS a scholar' do
    #create new user
    Capybara.reset_sessions!
    create_user_assign_as_scholar
    in_browser(:one) do
      #go to page and try to fill out form
      create_custom_collection({name: "Testing Collection", summary: 'asdf asdf asdf asdf asdf'})
      #expect page to have the title of the collection on it
      expect(page).to have_content ('Name: Testing Collection')
    end
  end
  
end

feature 'Scholar attaches files to a collection' do
  
  before :each do
    Capybara.reset_sessions!
    create_user_assign_as_scholar
    in_browser(:one) do
      create_custom_collection({name: "Testing Collection blah blah blah", summary: 'asdf asdf asdf asdf asdf'})
    end
  end
  
  scenario 'succeeds when the file is for the image and is a jpg' do
    user_attach_file({
      id: '1',
      button_name: 'custom_collection_image',
      file_name: 'test_jpg.jpg'
    })
    expect(page).to have_content("Image: /uploads/custom_collection/image/1/test_jpg.jpg")
  end
  
  scenario 'succeeds when the file is for the image and is a png' do
    user_attach_file({
      id: '1',
      button_name: 'custom_collection_image',
      file_name: 'blue.png'
    })
    expect(page).to have_content("Image: /uploads/custom_collection/image/1/blue.png")
  end
  
  scenario 'succeeds when the file is for the image and is a gif' do
    user_attach_file({
      id: '1',
      button_name: 'custom_collection_image',
      file_name: 'gif_test.gif'
    })
    expect(page).to have_content("Image: /uploads/custom_collection/image/1/gif_test.gif")
  end
  
  scenario 'fails when the file is for the image and is not of the proper type' do
    user_attach_file({
      id: '1',
      button_name: 'custom_collection_image',
      file_name: 'test_file.txt'
    })
    expect(page).to have_content("You are not allowed to upload \"txt\" files, allowed types: jpg, jpeg, gif, png
")
  end
  
  scenario 'succeeds when the file is for the article and is a txt' do
    user_attach_file({
      id: '1',
      button_name: 'custom_collection_article',
      file_name: 'test_file.txt'
    })
    expect(page).to have_content("Article: /uploads/custom_collection/article/1/test_file.txt")
  end
  
  scenario 'succeeds when the file is for the article and is a doc' do
    user_attach_file({
      id: '1',
      button_name: 'custom_collection_article',
      file_name: 'test_doc_file.doc'
    })
    expect(page).to have_content("Article: /uploads/custom_collection/article/1/test_doc_file.doc")
  end
  
  scenario 'succeeds when the file is for the article and is a pdf' do
    user_attach_file({
      id: '1',
      button_name: 'custom_collection_article',
      file_name: 'test_file.pdf'
    })
    expect(page).to have_content("Article: /uploads/custom_collection/article/1/test_file.pdf")
  end
  
  scenario 'fails when the file is for the article and is a jpg' do
    user_attach_file({
      id: '1',
      button_name: 'custom_collection_article',
      file_name: 'test_jpg.jpg'
    })
    expect(page).to have_content("You are not allowed to upload \"jpg\" files, allowed types: pdf, doc, txt")
  end
  
end

feature 'User tries to edit a collection' do
  
  scenario 'when the user is not signed in' do
    Capybara.reset_sessions!
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
    Capybara.reset_sessions!
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
    Capybara.reset_sessions!
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
    Capybara.reset_sessions!
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

#need to figure out user flow for this first
feature 'User tries to delete a collection' do
  
  before :each do
    create_user_assign_as_scholar
    in_browser(:one) do
      #create a collection in b1 by the user1
      create_custom_collection({name: "Testing Collection", summary: 'asdf asdf asdf asdf asdf'})
    end
  end
  
  scenario 'when the user is not signed in'
  
  scenario 'when the user is signed in but not a scholar'
  
  scenario 'when the user is signed in IS a scholar BUT did not create'
  
  scenario 'when the user is signed in IS a scholar DID create'
  
end
