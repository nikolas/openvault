class CustomCollectionCollab < ActiveRecord::Base
  belongs_to :user
  belongs_to :custom_collection
end