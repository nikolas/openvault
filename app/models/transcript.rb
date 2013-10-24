
class Transcript < OpenvaultAsset
  
  belongs_to :video, :property => :transcript_video
  belongs_to :audio, :property => :transcript_audio
  # belongs_to :asset_collection, :property => :is_part_of_collection
  
  # def self.model_name
  #   OpenvaultAsset.model_name
  # end
  
end