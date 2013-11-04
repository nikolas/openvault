class AddClasstypeToCustomCollectionItems < ActiveRecord::Migration
  def change
    add_column :custom_collection_items, :kind, :string
  end
end
