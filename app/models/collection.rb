class Collection < ActiveRecord::Base
  attr_accessible :name, :summary, :image, :position, :display_in_carousel
  
  mount_uploader :image, CollectionImageUploader
  
  acts_as_list
end
