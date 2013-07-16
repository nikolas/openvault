class CreateCollections < ActiveRecord::Migration
  def change
    create_table :collections do |t|
      t.string :name
      t.text :summary
      t.integer :order_number
      t.boolean :display_in_carousel
      t.string :image
      t.timestamps
    end
  end
end
