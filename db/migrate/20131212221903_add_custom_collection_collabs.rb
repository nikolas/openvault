class AddCustomCollectionCollabs < ActiveRecord::Migration
  def change
    create_table :custom_collection_collabs do |t|
      t.belongs_to :user
      t.belongs_to :custom_collection
      t.timestamps
    end
  end
end
