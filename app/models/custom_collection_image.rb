class CustomCollectionImage < ActiveRecord::Base
  attr_accessible :alt_text, :image, :rights, :custom_collection_id
  
  belongs_to :custom_collection
  
  #validates_presence_of :image, :on => :create, :message => "can't be blank"
  validates_format_of :image, :with => %r{\.(png|jpg|jpeg|gif)$}i, :message => "file must be png, jpg or gif"
  
  mount_uploader :image, CustomCollectionImageUploader
  
end
