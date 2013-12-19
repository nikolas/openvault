class CreateOrgsUsers < ActiveRecord::Migration
  def change
    create_table :orgs_users do |t|
      t.belongs_to :user
      t.belongs_to :org
    end
  end
end
