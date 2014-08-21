class Transcript < OpenvaultAsset

  belongs_to :video, :property => :transcript_video
  belongs_to :audio, :property => :transcript_audio

  has_metadata 'tei', :type => TeiDatastream 
  
  # def to_solr(solr_document={}, options={})
  #   super(solr_document, options)
  #   # Solrizer.insert_field(solr_document, "transcript_path", self.transcript_path, :displayable)
  #   return solr_document
  # end

  def relate_asset asset
    case asset
    when Video
      self.video = asset
    when Audio
      self.audio = asset
    else
      super asset
    end
  end
  
end
