class Ability
  include CanCan::Ability
  include Hydra::Ability

  # override #custom_permissions from Hydra::Ability. This is a hook that allows
  # us to keep the default permissions set in Hydra::Ability#initialize.
  def custom_permissions

    # can create new Comments
    can :create, Comment

    # can do any action on Comment if Comment belongs to logged in User
    can :manage, Comment, :user_id => current_user.id

    custom_collection_permissions
  end

  def create_permissions
    # do nothing. This is to override Hydra::Ability#create_permissions, which grants
    # create permissions for any object to any registered user.
  end

  def custom_collection_permissions
    # can read any Custom Collections
    can :read, CustomCollection

    # can create a new CustomCollection if the User is a scholar
    can :create, CustomCollection if current_user.is_scholar?

    # Can update, add items, removes items only if owned by the currently logged in user.
    # No one can delete custom collections at this time.
    can [:update, :add_item, :remove_item], CustomCollection, owner: current_user
  end
end
