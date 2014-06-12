class CreateSponsorship < ActiveRecord::Migration
  def change
    create_table :sponsorships do |t|
      t.integer :artifact_id
      t.integer :user_id
      t.boolean :confirmed, default: false
      t.timestamps
    end
  end
end
