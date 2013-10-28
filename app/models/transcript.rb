
class Transcript < OpenvaultAsset
  
  belongs_to :video, :property => :transcript_video
  belongs_to :audio, :property => :transcript_audio
  # belongs_to :asset_collection, :property => :is_part_of_collection
  
  def to_solr(solr_document={}, options={})
    super(solr_document, options)
    Solrizer.insert_field(solr_document, "transcript_path", self.transcript_file, :displayable)
    return solr_document
  end
  
  def transcript_path
    "http://media.wgbh.org/streaming/transcripts/#{self.pid}.xml"
  end
  
end