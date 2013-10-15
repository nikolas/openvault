class AssetCollection < OpenvaultAsset
  
  # has_many :videos, :property => :is_video_of
#   has_many :audios, :property => :is_audio_of
#   has_many :images, :property => :is_image_of
  
  def self.model_name
    OpenvaultAsset.model_name
  end
  
  
  # metadata for Program
  #     - episodic info
  #     - segment info (e.g. "part 1 of 3")
  #     - dates (e.g. when it aired)
  #     - producer info
  #     - people involved (e.g. interviewees, talent, etc)
  #     - copyright info
end
