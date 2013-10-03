class Video < OpenvaultAsset
  attr_accessor :length, :people, :format
  
  COVERAGE = ['complete', 'clip', 'segment']
  
  has_many :transcript, :property => :is_part_of
  belongs_to :program, :property => :is_part_of_program
  
  validates_inclusion_of :attribute, :in => COVERAGE
  
  
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