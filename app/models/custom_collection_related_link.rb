class CustomCollectionRelatedLink < ActiveRecord::Base
  attr_accessible :custom_collection_id, :desc, :link
  
  belongs_to :custom_collection
  
  validate :is_url?
  
  def is_url?
    true
  end
end
