class AddProfileFieldsToUsers < ActiveRecord::Migration
  def change
    add_column :users, :first_name, :string
    add_column :users, :last_name, :string
    add_column :users, :postal_code, :string
    add_column :users, :country, :string
    add_column :users, :mla_updates, :boolean
    add_column :users, :terms_and_conditions, :boolean
  end
end
