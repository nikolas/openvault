class VideoTranscript < Transcript
  belongs_to :video, :property => :is_part_of
  #Metadata for transcript
  # - 
end