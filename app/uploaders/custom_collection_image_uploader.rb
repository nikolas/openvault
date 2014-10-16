# encoding: utf-8

class CustomCollectionImageUploader < CarrierWave::Uploader::Base

  include CarrierWave::MiniMagick

  storage :file
  
  def store_dir
    "uploads/#{model.class.to_s.underscore}/#{mounted_as}/#{model.id}"
  end
  
  process :to_image
  
  version :thumb do
    process resize_to_fill: [50, 50]
  end
  
  version :small do
    process resize_to_fill: [100, 100]
  end
  
  version :med do
    process resize_to_fill: [200, 200]
  end
  
  version :carousel do
    process resize_to_fill: [600, 450]
  end
  
  version :large do
    process resize_to_limit: [400, 400]
  end
  
  def to_image
    manipulate! do |img|
      if file.path =~ /\.(?:gif|png)/i
        img.format 'png'
      else
        img.format 'jpg'
      end
      img = yield(img) if block_given?
      img
    end
  end
  
  def extension_white_list
    %w(jpg jpeg gif png)
  end
  

end
