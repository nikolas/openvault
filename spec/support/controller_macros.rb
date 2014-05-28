module ControllerMacros

  def skip_cancan
    before(:each) do
      @ability = Object.new
      @ability.extend(CanCan::Ability)
      @ability.can :manage, :all
      @controller.stub(:current_ability).and_return(@ability)
    end
  end

  # TODO: remove the admin_user model and user the User model with admin: true
  def login_admin_user
    before(:each) do
      @request.env["devise.mapping"] = Devise.mappings[:user]
      sign_in FactoryGirl.create(:user, :admin)
    end
  end

  def login_user
    before(:each) do
      @request.env["devise.mapping"] = Devise.mappings[:user]
      @user = FactoryGirl.create(:user)
      @user.confirm!
      sign_in @user
    end
  end

  def login_admin
    before(:each) do
      @request.env["devise.mapping"] = Devise.mappings[:user]
      sign_in FactoryGirl.create(:user, :admin)
    end
  end
end
