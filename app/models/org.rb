class Org < ActiveRecord::Base
  attr_accessible :desc, :name

  has_many :owned_collections, as: :owner, class_name: CustomCollection
end
