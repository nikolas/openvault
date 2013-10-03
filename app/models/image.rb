#Should this belong to audio or video stream?
class Transcript < OpenvaultAsset
  
  belongs_to :video, :property => :is_trans_of
  
end