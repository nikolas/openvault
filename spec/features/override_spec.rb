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
  
  it "non-existent returns 404" do
    visit "/some/crazy/url.xml"
    expect_404
  end
  
  it "weird returns 404" do
    visit '/!@#$%^&*()_'+"\u2603"
    expect_404
  end
  
  def expect_404
    expect(page.status_code).to eq(404)
    expect(page).to have_content("Sorry: We can not find that record.")
    expect(page.response_headers['Content-Type']).to eq("text/html; charset=utf-8")
  end
  
end
