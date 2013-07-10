class AddLinkTitleToMosaicItems < ActiveRecord::Migration
  def up
    add_column :mosaic_items, :link_title, :string
  end

  def down
    remove_column :mosaic_items, :link_title, :string
  end
  
end
