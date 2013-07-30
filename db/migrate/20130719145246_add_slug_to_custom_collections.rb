class AddSlugToCustomCollections < ActiveRecord::Migration
  def change
    add_column :custom_collections, :slug, :string
  end
end
