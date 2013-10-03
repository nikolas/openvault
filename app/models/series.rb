class Series < OpenvaultAsset
  # attr_accessible :title, :body
  has_many :programs, :property => :has_programs_of
  
  # metadata for Series
  #     - dates / date ranges (e.g. when it aired)
  #     - producer info
  
  def videos
    nil
  end
  
  def audios
    nil
  end
  
  def images
    nil
  end
  
end
