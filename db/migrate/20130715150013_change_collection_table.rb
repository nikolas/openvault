class ChangeCollectionTable < ActiveRecord::Migration
  def change
    rename_column :collections, :order_number, :position
  end
end
