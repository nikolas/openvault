#Should this belong to audio or video stream?
class Image < OpenvaultAsset
  
  belongs_to :video, :property => :image_video
  belongs_to :audio, :property => :image_audio
  
  def to_solr(solr_document={}, options={})
    super(solr_document, options)
    Solrizer.insert_field(solr_document, "image_path", self.image_file, :displayable)
    return solr_document
  end
  
  def image_file
    "http://media.wgbh.org/streaming/images/#{self.pid}.jpg"
  end
  
end