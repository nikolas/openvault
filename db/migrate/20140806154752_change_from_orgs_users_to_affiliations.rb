class ChangeFromOrgsUsersToAffiliations < ActiveRecord::Migration
  def up
    User.all.each do |user|
      if user.orgs.present?
        primary = 1
        title = user.title
        user.orgs.each do |org|
          Affiliation.create!(user_id: user.id, org_id: org.id, title: title, primary: primary)
        end
        primary = 0
        title = nil
      end
    end

    drop_table :orgs_users
    remove_column :users, :title
  end

  def down
    add_column :users, :title, :string
    User.reset_column_information
    execute "CREATE TABLE `orgs_users` (`id` int(11) NOT NULL AUTO_INCREMENT, `user_id` int(11) DEFAULT NULL, `org_id` int(11) DEFAULT NULL, PRIMARY KEY (`id`)) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8"
    Affiliation.all.each do |affil|
      affil.user.orgs << affil.org
      affil.user.title = affil.title
      affil.user.save!
    end
  end
end
