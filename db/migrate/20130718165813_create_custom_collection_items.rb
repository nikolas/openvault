class CreateCustomCollectionItems < ActiveRecord::Migration
  def change
    create_table :custom_collection_items do |t|
      t.string :cat_slug
      t.integer :custom_collection_id
      t.text :annotations

      t.timestamps
    end
  end
end
