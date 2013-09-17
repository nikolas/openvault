class Audio < ActiveFedora::Base
  COVERAGE = ['complete', 'clip', 'segment']
  has_many :transcripts, :property => :is_part_of
  belongs_to :program, :property => :is_part_of
  #Audio Metadata
  # - Length
  # - People involved
end