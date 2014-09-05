require 'spec_helper'
require 'affiliations_helper'
include AffiliationsHelper

Capybara.asset_host = 'http://localhost:3000'

feature "standard user show page" do
  let(:user) { create :user }

  scenario "with title and org displays both" do
    affiliation = FactoryGirl.create(:affiliation, primary: true, user: user)
    visit user_path user
    expect(page).to have_content("#{user.primary_title} — #{user.primary_organization}")
  end

  scenario "with multiple orgs" do
    affiliation1 = FactoryGirl.create(:affiliation, primary: true, user: user)
    2.times { FactoryGirl.create(:affiliation, user: user, title: nil) }
    visit user_path user
    expect(page).to have_content("#{user.primary_title} — #{user.primary_organization}")
    expect(page).to have_content("#{user.orgs.second.name}")
    expect(page).to have_content("#{user.orgs.third.name}")
  end
  
  scenario "displays user full name" do
    visit user_path user
    expect(page).to have_content(user.full_name)
  end

  scenario "displays digitization tab by default" do
    visit user_path user
    expect(page).to have_content("#{user.full_name} does not have any digitization requests")
  end  
end

feature "user without bio show page" do
  let(:bioless_user) { create :bioless_user }

  scenario "does not display \"About\" Tab" do
    visit user_path bioless_user
    expect(page).not_to have_selector("a[href*='#about']")
  end
end

feature "scholar user show page" do
  let(:scholar_user) { create :scholar_user }
  
  scenario "displays custom collection tab by default" do
    visit user_path scholar_user
    expect(page).to have_content("#{scholar_user.full_name} does not have any collections yet.")
  end
end
