class Ability
  include CanCan::Ability
  include Hydra::Ability

  def initialize(user)
    if user
      
      can :manage, Collection
      
      can [:show, :index], CustomCollection
      
      can [:create, :new], CustomCollection do |coll|
        user.is_scholar?
      end
      
      can [:edit, :destroy, :delete, :update], CustomCollection do |coll|
        user.is_scholar? && coll.user_can_edit?(user)
      end
      
    else
      can :manage, Collection

      can [:show, :index], CustomCollection
    end
  end
end
