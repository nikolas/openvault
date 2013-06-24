class CreateMosaics < ActiveRecord::Migration
  def change
    create_table :mosaics do |t|
      t.string :slug

      t.timestamps
    end
  end
end
