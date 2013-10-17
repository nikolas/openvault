#Should this belong to audio or video stream?
class Image < OpenvaultAsset
  
  belongs_to :video, :property => :image_video
  belongs_to :audio, :property => :image_audio
  
end