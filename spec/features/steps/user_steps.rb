module UserSteps

  def submit_login_form(values={})
    values.symbolize_keys!
    go_here '/users/sign_in'
    fill_in 'user_email', with: values[:email] unless values[:email].nil?
    fill_in 'user_password', with: values[:password] unless values[:password].nil?
    check 'user_remember_me' unless [true, 1, '1'].include? values[:remember_me]  
    click_button 'Log in'
  end

  def submit_registration_form (values={})
    values.symbolize_keys!
    go_here '/users/sign_up'
    fill_in 'user_email', with: values[:email] unless values[:email].nil?
    fill_in 'user_password', with: values[:password] unless values[:password].nil?
    fill_in 'user_password_confirmation', with: values[:password] unless values[:password].nil?
    fill_in 'user_first_name', with: values[:first_name] unless values[:first_name].nil?
    fill_in 'user_last_name', with: values[:last_name] unless values[:last_name].nil?
    fill_in 'user_postal_code', with: values[:postal_code] unless values[:postal_code].nil?
    check 'user_mla_updates' unless values[:mla_updates].nil?
    check 'user_terms_and_conditions' unless values[:terms_and_conditions].nil?
    select values[:country], from: 'user_country' unless values[:country].nil?
    click_button 'Register'
  end
  
  def handle_js_confirm(accept=true)
    page.evaluate_script "window.original_confirm_function = window.confirm"
    page.evaluate_script "window.confirm = function(msg) { return #{!!accept}; }"
    yield
    page.evaluate_script "window.confirm = window.original_confirm_function"
  end
  
  def create_admin_user
    FactoryGirl.create(:admin_user, email: 'admin@example.com', password: 'password', password_confirmation: 'password')
  end
  
  def login_as_admin(values={})
    values.symbolize_keys!
    create_admin_user unless values[:create_admin] == "false"
    go_here '/admin/login'
    fill_in 'admin_user_email', with: 'admin@example.com'
    fill_in 'admin_user_password', with: 'password'
    click_button 'Login'
  end
  
  def assign_user_as_scholar(values={})
    values.symbolize_keys!
    login_as_admin({create_admin: values[:create_admin]}) unless values[:create_admin] == 'false'
    go_here "/admin/users/#{values[:id]}/edit"
    within("#user_role_input") do
      select 'scholar', from: 'Role'
    end
    click_button 'Update User'
  end
  
  def in_browser(name)
    Capybara.session_name = name
    yield
  end
  
  def create_user_assign_as_scholar
    in_browser(:one) do
      submit_registration_form({email: "valid_#{Random.new.rand(10..100)}@me.com", password: '123456789', first_name: 'John', last_name: 'Smith', postal_code: '12345', country: 'United Kingdom', mla_updates: '1', terms_and_conditions: '1'})
    end
    in_browser(:two) do
      assign_user_as_scholar({id: '1'})
    end
  end
  
end