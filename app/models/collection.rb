class Collection < ActiveRecord::Base
  attr_accessible :name, :summary, :image, :order_number, :display_in_carousel
  
  mount_uploader :image, CollectionImageUploader
end
