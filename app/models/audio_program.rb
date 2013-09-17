class AudioProgram < OpenvaultAsset
  # attr_accessible :title, :body
  belongs_to :series, :property => :is_part_of
  has_many :videos, :property => :is_part_of
  has_many :audios, :property => :is_part_of
  
end
