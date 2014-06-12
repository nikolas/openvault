class AddPidToArtifact < ActiveRecord::Migration
  def change
  	add_column :artifacts, :pid, :string
  end
end
