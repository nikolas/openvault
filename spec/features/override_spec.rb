require 'spec_helper'
require 'openvault'

describe "visiting override page", type: :feature do
  
  it "series-collections are good" do
    visit '/catalog/advocates-advocates'
    expect(current_url).to include('/catalog/advocates-advocates')
    expect(page).to have_css('h1', text: 'The Advocates')
  end
  
  it "series-collections redirect" do
    visit '/collections/advocates-advocates'
    expect(current_url).to include('/catalog/advocates-advocates')
    expect(page).to have_css('h1', text: 'The Advocates')
  end
  
  it "collections-collections are good" do
    visit '/collections/vault-from-the-vault'
    expect(current_url).to include('/collections/vault-from-the-vault')
    expect(page).to have_css('h1', text: 'From The Vault')
  end
  
  it "collections index is good" do
    visit '/collections'
    expect(current_url).to include('/collections')
    expect(page).to have_css('h2', text: 'Collections')
  end
  
end
