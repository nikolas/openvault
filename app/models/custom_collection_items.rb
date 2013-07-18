class CustomCollectionItems < ActiveRecord::Base
  
  attr_accessible :annotations, :cat_slug, :custom_collection_id
  
  belongs_to :custom_collection
  
  validates_presence_of :cat_slug, :on => :create, :message => "can't be blank"
  validates_presence_of :custom_collection_id, :on => :create, :message => "can't be blank"
  
  serialize :annotations, HashWithIndifferentAccess
  
end
