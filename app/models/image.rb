#Should this belong to audio or video stream?
class Image < OpenvaultAsset
  
  belongs_to :video, :property => :image_video
  belongs_to :audio, :property => :image_audio
  belongs_to :series, :property => :series_image


  def relate_asset asset
    if asset.is_a? Video
      self.video = asset
    elsif asset.is_a? Audio
      self.audio = asset
    else
      super asset
    end
  end
  
  def to_solr(solr_document={}, options={})
    super(solr_document, options)
    Solrizer.insert_field(solr_document, "image_path", self.image_file, :displayable)
    return solr_document
  end
  
  def image_file
    "http://media.wgbh.org/streaming/images/#{self.pid}.jpg"
  end

  def title
    self.pbcore.image_title.first || "image"
  end
  
end