module LoginHelpers

  def sign_in_with_form(email, password)
    visit new_user_session_path
    fill_in 'user_email', with: email
    fill_in 'user_password', with: password
    click_button 'Sign in'
  end

  def log_in(user)
    sign_in_with_form(user.email, user.password)
  end

  def sign_in_as_role(role)
    @user = FactoryGirl.create(:user, role)
    @user.confirm!
    sign_in_with_form(@user.email, @user.password)
    @user
  end

  def sign_in_as_admin
    sign_in_as_role(:admin)
  end

end
