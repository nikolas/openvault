class RenameMosaicItems < ActiveRecord::Migration
  def up
    rename_table :mosaics, :mosaic_items
  end

  def down
    rename_table :mosaic_items, :mosaics
  end
end
