class MosaicItem < ActiveRecord::Base
  attr_accessible :slug, :link_title
  
  #mount_uploader :thumbnail, MosaicThumbnailUploader
end