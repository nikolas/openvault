require 'random_record'

class Org < ActiveRecord::Base

  include RandomRecord

  attr_accessible :desc, :name, :user_ids
  
  has_many :owned_collections, as: :owner, class_name: CustomCollection

  has_and_belongs_to_many :users

  validates :name, presence: true

  def full_name
    # TODO: does anything use this?
  	"Org: #{name}"
  end
end
