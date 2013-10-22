#Should this belong to audio or video stream?
class Transcript < OpenvaultAsset
  
  belongs_to :video, :property => :is_trans_of_video
  belongs_to :asset_collection, :property => :is_part_of_collection
  
  def self.model_name
    OpenvaultAsset.model_name
  end
  
end