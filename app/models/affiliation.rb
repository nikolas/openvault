class Affiliation < ActiveRecord::Base
  attr_accessible :org_id, :primary, :title, :user_id

  belongs_to :org
  belongs_to :user
end
