#Should this belong to audio or video stream?
class Image < OpenvaultAsset
  
  belongs_to :video, :property => :is_trans_of
  
  def self.model_name
    OpenvaultAsset.model_name
  end
  
end