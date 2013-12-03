class CustomCollectionRelatedLink < ActiveRecord::Base
  attr_accessible :custom_collection_id, :desc, :link
  
  belongs_to :custom_collection
  
  validates_presence_of :link, :on => :create, :message => "can't be blank"
  validates_presence_of :desc, :on => :create, :message => "can't be blank"
  validates_format_of :link, :with => URI::regexp(%w(http https))
  
end
