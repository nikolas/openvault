class Transcript < OpenvaultAsset
  belongs_to :video, :property => :transcript_video
  belongs_to :audio, :property => :transcript_audio
  belongs_to :program, :property => :transcript_program

  has_metadata 'tei', :type => TeiDatastream 
  
  # def to_solr(solr_document={}, options={})
  #   super(solr_document, options)
  #   # Solrizer.insert_field(solr_document, "transcript_path", self.transcript_path, :displayable)
  #   return solr_document
  # end
  
end
