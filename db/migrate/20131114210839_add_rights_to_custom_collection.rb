class AddRightsToCustomCollection < ActiveRecord::Migration
  def change
    add_column :custom_collections, :article_rights, :text
    add_column :custom_collections, :credits, :text
  end
end
