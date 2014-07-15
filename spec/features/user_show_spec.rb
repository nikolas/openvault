require 'spec_helper'

feature "user show page" do
  let(:user) { create :user }
  
  scenario "displays user full name" do
    visit user_path user
    expect(page).to have_content(user.full_name)
  end
end
