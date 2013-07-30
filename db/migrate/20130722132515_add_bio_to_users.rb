class AddBioToUsers < ActiveRecord::Migration
  def change
    add_column :users, :bio, :text
    add_column :users, :title, :string
    add_column :users, :organization, :string
    add_column :users, :avatar, :string
  end
end
