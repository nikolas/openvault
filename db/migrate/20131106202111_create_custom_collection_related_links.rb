class CreateCustomCollectionRelatedLinks < ActiveRecord::Migration
  def change
    create_table :custom_collection_related_links do |t|
      t.integer :custom_collection_id
      t.string :link
      t.text :desc

      t.timestamps
    end
  end
end
