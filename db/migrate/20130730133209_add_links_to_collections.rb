class AddLinksToCollections < ActiveRecord::Migration
  def change
    add_column :collections, :mid_content, :text
    add_column :collections, :lower_content, :text
  end
end
