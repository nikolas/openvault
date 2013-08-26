class CreateCustomCollections < ActiveRecord::Migration
  def change
    create_table :custom_collections do |t|
      t.string :name
      t.text :summary
      t.string :image
      t.string :article

      t.timestamps
    end
  end
end
