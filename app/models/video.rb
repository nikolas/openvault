class Video < OpenvaultAsset
  
  COVERAGE = ['complete', 'clip', 'segment']
  
  has_many :transcript, :property => :is_part_of
  belongs_to :program, :property => :is_part_of_program
  
  
  def self.model_name
    OpenvaultAsset.model_name
  end
  
  
  def length
    nil
  end
  
  def people
    nil
  end
  
  def format
    nil
  end
  
  #Video Metadata
  # - Length
  # - People involved
  # - formats
end