class CustomCollectionItem < ActiveRecord::Base
  
  attr_accessible :annotations, :cat_slug, :custom_collection_id, :openvault_asset_pid
  
  belongs_to :custom_collection
  belongs_to :openvault_asset, :foreign_key => :openvault_asset_pid
  
  validates_presence_of :openvault_asset_pid, :on => :create, :message => "can't be blank"
  validates_presence_of :custom_collection_id, :on => :create, :message => "can't be blank"
  
  serialize :annotations, HashWithIndifferentAccess
  
end
