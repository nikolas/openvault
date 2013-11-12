require 'spec_helper'
require 'helpers/test_helper'
include Warden::Test::Helpers
Warden.test_mode!

#Many of these will need to change as the UI changes
feature 'User tries to create a custom collection' do
  
  before :each do
    Warden.test_reset!
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
    expect(page).to have_css 'div#collection_container'
  end
  
end

feature 'Scholar attaches files to a collection' do
  #need a better way to test these one the final page designs are active
  before :each do
    Warden.test_reset!
    @scholar = create(:user, role: 'scholar')
    @cc = create(:custom_collection, user_id: @scholar.id, name: "Testing Collection blah blah blah", summary: 'asdf asdf asdf asdf asdf')
  end
  
  scenario 'succeeds when the file is for the article and is a pdf' do
    login_as(@scholar, :scope => :user, :run_callbacks => false)
    user_attach_file({
      id: @cc.id,
      button_name: 'custom_collection_article',
      file_name: 'test_file.pdf'
    })
    cont = page.find_by_id('outerContainer')
    cont[:'data-pdf'].should match(/test_file.pdf/)
  end
  
  scenario 'fails when the file is for the article and is a jpg' do
    login_as(@scholar, :scope => :user, :run_callbacks => false)
    user_attach_file({
      id: @cc.id,
      button_name: 'custom_collection_article',
      file_name: 'test_jpg.jpg'
    })
    expect(page).to have_content("You are not allowed to upload \"jpg\" files, allowed types: pdf")
  end
  
end

feature 'User tries to edit a collection' do
  
  before :each do
    Warden.test_reset!
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

feature "User adds a catalog item to a collection" do
  before :each do
    Warden.test_reset!
    @scholar1 = create(:user, role: 'scholar')
    @member = create(:user)
    @custom_collection1 = create(:custom_collection, user_id: @scholar1.id, name: 'Testing 123123', summary: 'Testingasdfjasldkjf')
    @item = Video.create!
  end
  
  scenario 'when they are signed in as a scholar'do
    login_as(@scholar1, :scope => :user, :run_callbacks => false)
    visit "/video/#{@item.pid}"
    find("li.add_to_collection").click_link "Add to my collection"
    expect(page).to have_content 'In your collection'
  end
  
  scenario 'when they are signed in as a non-scholar' do
    login_as(@member, :scope => :user, :run_callbacks => false)
    visit "/video/#{@item.pid}"
    expect(page).not_to have_content('Add to my collection')
  end
  
  scenario 'when they are not signed it' do
    visit "/video/#{@item.pid}"
    expect(page).not_to have_content('Add to my collection')
  end
  
end

feature "User removes a catalog item from a collection" do
  before :each do
    Warden.test_reset!
    @scholar1 = create(:user, role: 'scholar')
    @member = create(:user)
    @custom_collection1 = create(:custom_collection, user_id: @scholar1.id, name: 'Testing 123123123123', summary: 'Testingasdfjasldkjf')
    @item = Video.create!
    create(:custom_collection_item, :custom_collection_id => @custom_collection1.id, :openvault_asset_pid => @item.pid, :kind => 'Video')
  end
  
  scenario 'when they are signed in as a scholar' do
    login_as(@scholar, :scope => :user, :run_callbacks => false)
    visit "/custom_collections/#{@custom_collection1.id}"
    click_link "Remove"
    expect(page).not_to have_content("Videos:")
  end
  
  scenario 'when they are signed in as a non-scholar' do
    login_as(@member, :scope => :user, :run_callbacks => false)
    visit "/custom_collections/#{@custom_collection1.id}"
    expect(page).not_to have_xpath("//a[@href=\"/custom_collections/#{@custom_collection1.id}/remove_item/?asset_id=#{@item.pid}\"]")
  end
  
  scenario 'when they are not signed it' do
    visit "/custom_collections/#{@custom_collection1.id}"
    expect(page).not_to have_xpath("//a[@href=\"/custom_collections/#{@custom_collection1.id}/remove_item/?asset_id=#{@item.pid}\"]")
  end
end
