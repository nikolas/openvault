# NOTE: This migration changes an association for CustomCollection model to polymorphic.
# Prior to this migration a User has_many CustomCollection.
# After this migration, other models can has_many CustomCollection too.
# If we did not want to preserve data, we would use `t.references`
# (see http://guides.rubyonrails.org/association_basics.html#polymorphic-associations).
# But I couldn't find a way to use this elegantly while preserving data. So we use a more explicity way,
# knowing that using `references` creates two columns.. in our case `owner_id` and `owner_type`.

class ChangeUserToOwnerForCustomCollection < ActiveRecord::Migration

  def up
    rename_column :custom_collections, :user_id, :owner_id
    add_column :custom_collections, :owner_type, :string
    # prior to this, CustomCollection can only be owned by User, so assume that here and set `owner_type` accordingly.
    execute 'update custom_collections set owner_type="User" where owner_id is not null'
  end

  def down
    # First, nullify the IDs of any non-User owners. Otherwise might wind up with Users owning custom_collections that they shouldn't.
    # Unfortunately, if a non-User object owned the CustomCollection, then we will lose that info when rolling back before this migration.
    execute "update custom_collections set owner_id=NULL where owner_type != 'User'"
    # now change the `owner_id` column back to `user_id`...
    rename_column :custom_collections, :owner_id, :user_id
    # and drop the polymorphic `_type` column.
    remove_column :custom_collections, :owner_type
  end
end