class Series < OpenvaultAsset
  # attr_accessible :title, :body
  has_many :programs, :property => :is_part_of
  has_many :videos, :property => :is_part_of
  has_many :audios, :property => :is_part_of
  
  # metadata for Series
  #     - dates / date ranges (e.g. when it aired)
  #     - producer info
  
end
