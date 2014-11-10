require 'spec_helper'
require 'openvault'

describe "OverrideController.first_rest_list" do
  it 'works' do
    output = OverrideController.first_rest_list(<<-eof
      Washington, George
      Adams, John
    eof
    ) {|query| ['interview-2','interview-3','random','interview-1'].map{|item| query.gsub(/\W/,'-')+'-'+item}}
    expect(output).to eq([
        {:name=>"Washington, George", 
          :first=>"text-Washington-text-George-interview-1", 
          :rest=>["text-Washington-text-George-interview-2", "text-Washington-text-George-interview-3"]}, 
        {:name=>"Adams, John", 
          :first=>"text-Adams-text-John-interview-1", 
          :rest=>["text-Adams-text-John-interview-2", "text-Adams-text-John-interview-3"]}
      ])
  end
end

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
