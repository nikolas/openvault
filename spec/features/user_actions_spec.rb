require 'spec_helper'

feature 'Visitor signs up' do
  let(:user) { FactoryGirl.create(:user) }
  before(:each) do
    user.save
    visit destroy_user_session_url
  end

  scenario 'with valid info in all fields' do
    submit_registration_form({email: "valid_#{Random.new.rand(10..100)}@me.com", password: '123456789', first_name: 'John', last_name: 'Smith', country: 'United Kingdom', mla_updates: '1', terms_and_conditions: '1'})
    expect(page).to have_content('Log Out')
  end

  scenario 'with invalid email' do
    submit_registration_form({email: "valid_#{Random.new.rand(10..100)}", password: '123456789', first_name: 'John', last_name: 'Smith', country: 'United Kingdom', mla_updates: '1', terms_and_conditions: '1'})
    expect(page).to have_content('Email is invalid')
  end

  scenario 'with blank password' do
    submit_registration_form({email: "valid_#{Random.new.rand(10..100)}@me.com", password: '', first_name: 'John', last_name: 'Smith', country: 'United Kingdom', mla_updates: '1', terms_and_conditions: '1'})
    expect(page).to have_content('Password can\'t be blank')
  end

  scenario 'with blank name' do
    submit_registration_form({email: "valid_#{Random.new.rand(10..100)}@me.com", password: '123456789', first_name: '', last_name: 'Smith', country: 'United Kingdom', mla_updates: '1', terms_and_conditions: '1'})
    expect(page).to have_content('First name can\'t be blank')
  end

  scenario 'with blank last name' do
    submit_registration_form({email: "valid_#{Random.new.rand(10..100)}@me.com", password: '123456789', first_name: 'John', last_name: '', country: 'United Kingdom', mla_updates: '1', terms_and_conditions: '1'})
    expect(page).to have_content('Last name can\'t be blank')
  end

  scenario 'user can login after already signing up' do
    submit_login_form({email: user.email, password: user.password})
    expect(page).to have_content('Log Out')
  end

end

feature "Edit User Profile" do
  let (:user) { FactoryGirl.create(:user) }

  before :each do
    user.save!
    submit_login_form({email: user.email, password: user.password})
    visit edit_user_registration_path
    expect(page).to have_content('Edit your Open Vault profile')
  end

  after(:each) { visit destroy_user_session_url }

  scenario "user cannot view profile page when not logged in" do
    visit destroy_user_session_url
    visit user_root_path
    expect(page).to have_content('You must be logged in to view your profile')
  end

  # Add expectations for any field that does not require a password to be changed.
  scenario "does not require password to change most fields" do
    new_vals = {
      :first_name => "Bobby",
      :last_name => "Smitherson",
      :bio => "today we are testing",
      :country => "Afghanistan"
     }

    fill_in 'user_first_name', with: new_vals[:first_name]
    fill_in 'user_last_name', with: new_vals[:last_name]
    fill_in 'user_bio', with: new_vals[:bio]
    select new_vals[:country], from: "user_country"
    click_button 'Save Profile'

    user.reload
    user.first_name.should == new_vals[:first_name]
    user.last_name.should == new_vals[:last_name]
    user.bio.should == new_vals[:bio]
    user.country.should == new_vals[:country]
  end

  scenario "requires password to change email" do
    fill_in 'user_email', with: "a@b.com"
    fill_in 'user_current_password', with: '123456789'
    click_button 'Save Profile'
    user.reload
    user.email.should == "a@b.com"
  end

  scenario 'fails to change email if password is not supplied' do
    fill_in 'user_email', with: "a@b.com"
    click_button 'Save Profile'
    user.reload
    user.email.should_not == "a@b.com"
  end

  scenario 'fails to change email if password is incorrect' do
    fill_in 'user_email', with: "a@b.com"
    fill_in 'user_current_password', with: 'adfadssdfsadf'
    click_button 'Save Profile'
    user.reload
    user.email.should_not == "a@b.com"
  end

  scenario "allows changing password" do
    # fill in the current password. This password is set in the before(:each) block of this featere (see above).
    fill_in 'user_current_password', with: '123456789'

    # change the password to something different
    fill_in 'user_password', with: "abcdefgh"
    fill_in 'user_password_confirmation', with: "abcdefgh"
    click_button 'Save Profile'

    # now log out and log back in with the new password
    visit destroy_user_session_url
    submit_login_form({email: user.email, password: "abcdefgh"})

    # and we should be able to see a link for logging back out (i.e. we are now logged in)
    expect(page).to have_content('Log Out')
  end
end
