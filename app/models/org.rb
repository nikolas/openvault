class Org < ActiveRecord::Base
  attr_accessible :desc, :name

  has_and_belongs_to_many :users
end
