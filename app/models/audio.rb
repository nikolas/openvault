class Audio < OpenvaultAsset
  COVERAGE = ['complete', 'clip', 'segment']
  
  has_many :transcripts, :property => :has_transcript_of
  belongs_to :program, :property => :is_part_of_program
  
end