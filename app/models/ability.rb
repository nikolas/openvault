class Ability
  include CanCan::Ability

  def initialize(user)
    if user
      can :manage, Collection
      
      can [:show], CustomCollection
      
      can [:create, :new, :index], CustomCollection do |coll|
        user.is_scholar?
      end
      
      can [:edit, :destroy, :delete, :update], CustomCollection do |coll|
        user.is_scholar? && coll.user_can_edit?(user)
      end
      
    else
      can :manage, Collection
      can [:show], CustomCollection
    end
  end
end
