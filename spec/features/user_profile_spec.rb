require 'spec_helper'

feature 'User edits their profile' do
  let(:user) { FactoryGirl.create(:user) }

  before(:each) do
    visit destroy_user_session_url
  end

  def new_vals
    {
      :first_name => "Bobby",
      :last_name => "Smitherson",
      :bio => "today we are testing",
      :country => "Afghanistan"
    }
  end

  context 'when not logged in' do
    scenario "user cannot view profile page" do
      visit user_root_path
      expect(page).to have_content('You must be logged in to view your profile')
    end
  end

  context 'when logged in' do
    before(:each) do
      submit_login_form({email: user.email, password: user.password})
      expect(page).to have_content('Signed in successfully.')
      click_link 'Edit Profile'
      expect(page).to have_content('Edit your Open Vault profile')
    end

    # Add expectations for any field that does not require a password to be changed.
    scenario "changing first name, last name, country, and bio does not require password" do
      fill_in 'user_first_name', with: new_vals[:first_name]
      fill_in 'user_last_name', with: new_vals[:last_name]
      fill_in 'user_bio', with: new_vals[:bio]
      select new_vals[:country], from: "user_country"
      click_button 'Save Profile'
      expect(page).to have_content('You updated your account successfully.')
    end

    scenario "changing email works when password is entered" do
      fill_in 'user_email', with: "a@b.com"
      fill_in 'user_current_password', with: user.password
      click_button 'Save Profile'
      expect(page).to have_content('You updated your account successfully.')
    end

    scenario 'changing email fails if password is not supplied' do
      fill_in 'user_email', with: "a@b.com"
      click_button 'Save Profile'
      expect(page).to have_content('Current password can\'t be blank')
    end

    scenario 'fails to change email if password is incorrect' do
      fill_in 'user_email', with: "a@b.com"
      fill_in 'user_current_password', with: user.password.reverse
      click_button 'Save Profile'
      expect(page).not_to have_content('You updated your account successfully.')
      expect(page).to have_content('Current password is invalid')
    end

    scenario "allows changing password" do
      new_password = user.password.reverse
      fill_in 'user_current_password', with: user.password
      fill_in 'user_password', with: new_password
      fill_in 'user_password_confirmation', with: new_password
      click_button 'Save Profile'
      expect(page).to have_content('You updated your account successfully.')
    end

    scenario "changing password fails if current password is not supplied" do
      new_password = user.password.reverse
      fill_in 'user_password', with: new_password
      fill_in 'user_password_confirmation', with: new_password
      click_button 'Save Profile'
      expect(page).not_to have_content('You updated your account successfully.')
    end

    scenario "changing password fails if current password is incorrect" do
      new_password = user.password.reverse
      fill_in 'user_current_password', with: new_password
      fill_in 'user_password', with: new_password
      fill_in 'user_password_confirmation', with: new_password
      click_button 'Save Profile'
      expect(page).not_to have_content('You updated your account successfully.')
      expect(page).to have_content('Current password is invalid')
    end

    scenario "adding Organization results in only the organization name displayed" do
      fill_in 'user_organization', with: "Testing, Inc."
      click_button 'Save Profile'
      expect(page).to have_content('You updated your account successfully.')
      expect(page).to have_content('Testing, Inc.')
    end

    scenario "adding Title results in only the title name displayed" do
      fill_in 'user_title', with: "President"
      click_button 'Save Profile'
      expect(page).to have_content('You updated your account successfully.')
      expect(page).to have_content('President')
    end

    scenario "adding Organization and Title results in both being displayed with dash" do
      fill_in 'user_organization', with: "Testing, Inc."
      fill_in 'user_title', with: "President"
      click_button 'Save Profile'
      expect(page).to have_content('You updated your account successfully.')
      expect(page).to have_content('President — Testing, Inc.')
    end
  end
end
