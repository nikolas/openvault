class Org < ActiveRecord::Base
  attr_accessible :desc, :name

  has_and_belongs_to_many :users

  has_many :custom_collections, as: :owner
end
