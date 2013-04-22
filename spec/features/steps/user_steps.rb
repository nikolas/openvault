module UserSteps

  def submit_login_form(values={})
    values.symbolize_keys!
    go_here '/users/sign_in'
    fill_in 'user_email', with: values[:email] unless values[:email].nil?
    fill_in 'user_password', with: values[:password] unless values[:password].nil?
    check 'user_remember_me' unless [true, 1, '1'].include? values[:remember_me]  
    click_button 'Sign in'
  end

  def submit_registration_form (values={})
    values.symbolize_keys!
    go_here '/users/sign_up'
    fill_in 'user_email', with: values[:email] unless values[:email].nil?
    fill_in 'user_password', with: values[:password] unless values[:password].nil?
    fill_in 'user_password_confirmation', with: values[:password] unless values[:password_confirmation].nil?
    fill_in 'user_first_name', with: values[:first_name] unless values[:first_name].nil?
    fill_in 'user_last_name', with: values[:last_name] unless values[:last_name].nil?
    fill_in 'user_postal_code', with: values[:postal_code] unless values[:postal_code].nil?
    check 'user_mla_updates' unless values[:mla_updates].nil?
    check 'user_terms_and_conditions' unless values[:terms_and_conditions].nil?
    select values[:country], from: 'user_country' unless values[:country].nil?
    click_button 'Register'
  end
end