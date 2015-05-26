class DropMosaic < ActiveRecord::Migration
  def up
    drop_table('mosaic_items')
  end

  def down
    raise ActiveRecord::IrreversibleMigration
  end
end
