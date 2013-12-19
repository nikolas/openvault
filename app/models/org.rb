class Org < ActiveRecord::Base
  attr_accessible :desc, :name

  has_many :owned_collections, as: :owner, class_name: CustomCollection

  has_and_belongs_to_many :users

  validates :name, presence: true
end
