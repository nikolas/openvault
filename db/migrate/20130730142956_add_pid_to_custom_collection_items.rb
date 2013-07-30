class AddPidToCustomCollectionItems < ActiveRecord::Migration
  def change
    add_column :custom_collection_items, :openvault_asset_pid, :string
  end
end
