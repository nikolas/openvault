require 'spec_helper'
require 'helpers/test_helper'
include Warden::Test::Helpers
Warden.test_mode!

#Many of these will need to change as the UI changes
feature 'User tries to create a custom collection' do
  
  before :each do
    Capybara.reset_sessions!
    @scholar1 = create(:user, role: 'scholar')
    @member = create(:user)
    @custom_collection1 = create(:custom_collection, user_id: @scholar1.id)
  end
  
  scenario 'when the user is not signed in' do
    visit new_custom_collection_path
    expect(page).to have_content("You are not authorized to access this page.")
  end
  
  scenario 'when the user is signed in but not a scholar' do
    login_as(@member, :scope => :user, :run_callbacks => false)
    visit new_custom_collection_path
    expect(page).to have_content("You are not authorized to access this page.")
  end
  
  scenario 'when the user is signed in and IS a scholar' do
    login_as(@scholar1, :scope => :user, :run_callbacks => false)
    create_custom_collection({name: "Testing Collection", summary: 'asdf asdf asdf asdf asdf'})
    #expect page to have the title of the collection on it
    expect(page).to have_content ('Testing Collection')
  end
  
end

feature 'Scholar attaches files to a collection' do
  #need a better way to test these one the final page designs are active
  # before :each do
#     Capybara.reset_sessions!
#     create_user_assign_as_scholar
#     in_browser(:one) do
#       create_custom_collection({name: "Testing Collection blah blah blah", summary: 'asdf asdf asdf asdf asdf'})
#     end
#   end
#   
#   scenario 'succeeds when the file is for the image and is a jpg' do
#     user_attach_file({
#       id: '1',
#       button_name: 'custom_collection_image',
#       file_name: 'test_jpg.jpg'
#     })
#     expect(page.html).to have_content("<img alt=\"Med_test_jpg\" src=\"/uploads/custom_collection/image/1/med_test_jpg.jpg\">")
#   end
#   
#   scenario 'succeeds when the file is for the image and is a png' do
#     user_attach_file({
#       id: '1',
#       button_name: 'custom_collection_image',
#       file_name: 'blue.png'
#     })
#     expect(page).to have_content("Image: /uploads/custom_collection/image/1/blue.png")
#   end
#   
#   scenario 'succeeds when the file is for the image and is a gif' do
#     user_attach_file({
#       id: '1',
#       button_name: 'custom_collection_image',
#       file_name: 'gif_test.gif'
#     })
#     expect(page).to have_content("Image: /uploads/custom_collection/image/1/gif_test.gif")
#   end
#   
#   scenario 'fails when the file is for the image and is not of the proper type' do
#     user_attach_file({
#       id: '1',
#       button_name: 'custom_collection_image',
#       file_name: 'test_file.txt'
#     })
#     expect(page).to have_content("You are not allowed to upload \"txt\" files, allowed types: jpg, jpeg, gif, png
# ")
#   end
#   
#   scenario 'succeeds when the file is for the article and is a txt' do
#     user_attach_file({
#       id: '1',
#       button_name: 'custom_collection_article',
#       file_name: 'test_file.txt'
#     })
#     expect(page).to have_content("Article: /uploads/custom_collection/article/1/test_file.txt")
#   end
#   
#   scenario 'succeeds when the file is for the article and is a doc' do
#     user_attach_file({
#       id: '1',
#       button_name: 'custom_collection_article',
#       file_name: 'test_doc_file.doc'
#     })
#     expect(page).to have_content("Article: /uploads/custom_collection/article/1/test_doc_file.doc")
#   end
#   
#   scenario 'succeeds when the file is for the article and is a pdf' do
#     user_attach_file({
#       id: '1',
#       button_name: 'custom_collection_article',
#       file_name: 'test_file.pdf'
#     })
#     expect(page).to have_content("Article: /uploads/custom_collection/article/1/test_file.pdf")
#   end
#   
#   scenario 'fails when the file is for the article and is a jpg' do
#     user_attach_file({
#       id: '1',
#       button_name: 'custom_collection_article',
#       file_name: 'test_jpg.jpg'
#     })
#     expect(page).to have_content("You are not allowed to upload \"jpg\" files, allowed types: pdf, doc, txt")
#   end
  
end

feature 'User tries to edit a collection' do
  
  before :each do
    Capybara.reset_sessions!
    @scholar1 = create(:user, role: 'scholar')
    @scholar2 = create(:user, role: 'scholar')
    @member = create(:user)
    @custom_collection1 = create(:custom_collection, user_id: @scholar1.id)
    @custom_collection2 = create(:custom_collection, user_id: @scholar2.id)
  end
  
  scenario 'when the user is not signed in' do
    visit "/custom_collections/#{@custom_collection1.id}/edit"
    expect(page).to have_content 'You are not authorized to access this page.'
  end
  
  scenario 'when the user is signed in but not a scholar' do
    login_as(@member, :scope => :user, :run_callbacks => false)
    visit "/custom_collections/#{@custom_collection1.id}/edit"
    expect(page).to have_content 'You are not authorized to access this page.'
  end
  
  scenario 'when the user is signed in IS a scholar BUT did not create' do
    login_as(@scholar2, :scope => :user, :run_callbacks => false)
    visit "/custom_collections/#{@custom_collection1.id}/edit"
    expect(page).to have_content 'You are not authorized to access this page.'
  end
  
  scenario 'when the user is signed in IS a scholar DID create' do
    login_as(@scholar1, :scope => :user, :run_callbacks => false)
    visit "/custom_collections/#{@custom_collection1.id}/edit"
    fill_in 'custom_collection_name', with: 'Edited Testing Collection'
    click_button 'Update Custom collection'
    expect(page).to have_content 'Edited Testing Collection'
  end
  
end

#need to figure out user flow for this first
feature 'User tries to delete a collection' do
  
  before :each do
    Capybara.reset_sessions!
    @scholar1 = create(:user, role: 'scholar')
    @scholar2 = create(:user, role: 'scholar')
    @member = create(:user)
    @custom_collection1 = create(:custom_collection, user_id: @scholar1.id)
    @custom_collection2 = create(:custom_collection, user_id: @scholar2.id)
  end
  
  scenario 'when the user is not signed in'
  
  scenario 'when the user is signed in but not a scholar'
  
  scenario 'when the user is signed in IS a scholar BUT did not create'
  
  scenario 'when the user is signed in IS a scholar DID create'
  
end
