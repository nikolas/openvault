class CreateAffiliations < ActiveRecord::Migration
  def change
    create_table :affiliations do |t|
      t.integer :user_id
      t.integer :org_id
      t.string :title
      t.boolean :primary

      t.timestamps
    end
  end
end
