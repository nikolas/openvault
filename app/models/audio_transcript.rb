class AudioTranscript < Transcript
  belongs_to :audio, :property => :is_part_of
  #Metadata for transcript
  # - 
end