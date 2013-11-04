class Ability
  include CanCan::Ability
  include Hydra::Ability

  # def initialize(user)
  #   if user
  #     
  #     can :manage, Collection
  #     
  #     can [:show, :index], CustomCollection
  #     
  #     can [:edit, :destroy, :delete, :update], CustomCollection do |coll|
  #       user.is_scholar? && coll.user_can_edit?(user)
  #     end
  #     
  #     can [:create, :new], CustomCollection if user.is_scholar?
  #     
  #   else
  #     can :manage, Collection
  # 
  #     can [:show, :index], CustomCollection
  #   end
  #   #super
  # end
  
  def custom_permissions
    if @current_user
      can :create, Comment 
      can :manage, Comment, :user_id => @current_user.id
      can :manage, Collection
      
      can [:show, :index], CustomCollection
      
      can [:create, :new], CustomCollection if @current_user.is_scholar?
      
      cannot [:create, :new], CustomCollection if @current_user.is_member?
      
      can [:edit, :destroy, :delete, :update, :add_item, :remove_item], CustomCollection do |coll|
        @current_user.is_scholar? && coll.user_can_edit?(@current_user)
      end
      
    else
      can :manage, Collection
      can :read, Comment, :public => true
      can [:show, :index], CustomCollection
    end
    
  end
end
