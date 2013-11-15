class CreateCustomCollectionImages < ActiveRecord::Migration
  def change
    create_table :custom_collection_images do |t|
      t.string :image
      t.string :rights
      t.string :alt_text
      t.integer :custom_collection_id

      t.timestamps
    end
  end
end
