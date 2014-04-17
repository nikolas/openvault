# encoding: utf-8

class AvatarUploader < CarrierWave::Uploader::Base

  # Include RMagick or MiniMagick support:
  # include CarrierWave::RMagick
  include CarrierWave::MiniMagick

  # Include the Sprockets helpers for Rails 3.1+ asset pipeline compatibility:
  # include Sprockets::Helpers::RailsHelper
  # include Sprockets::Helpers::IsolatedHelper

  # Choose what kind of storage to use for this uploader:
  storage :file
  # storage :fog

  # Override the directory where uploaded files will be stored.
  # This is a sensible default for uploaders that are meant to be mounted:
  def store_dir
    "uploads/#{model.class.to_s.underscore}/#{mounted_as}/#{model.id}"
  end
  
  def default_url
    "fallback/" + [version_name, "default-avatar.png"].compact.join('_')
  end
  
  # process :to_image
  
  version :thumb do
    process resize_to_limit: [50, 50]
  end
  
  version :small do
    process resize_to_limit: [100, 100]
  end
  
  version :med do
    process resize_to_limit: [200, 200]
  end
  
  # def to_image
  #   binding.pry
  #   manipulate! do |img|
  #     if file.path =~ /\.(?:gif|png)/i
  #       img.format 'png'
  #     else
  #       img.format 'jpg'
  #     end
  #     img = yield(img) if block_given?
  #     img
  #   end
  # end
  
  def extension_white_list
    %w(jpg jpeg gif png)
  end
  
end
