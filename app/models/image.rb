#Should this belong to audio or video stream?
class Image < OpenvaultAsset
  belongs_to :video, :property => :image_video
  belongs_to :program, :property => :image_program
  belongs_to :series, :property => :series_image # TODO: doesn't seem right.
  
  def to_solr(solr_document={}, options={})
    super(solr_document, options)
    Solrizer.insert_field(solr_document, "image_url", self.image_url, :displayable)
    Solrizer.insert_field(solr_document, "has_related_video", [self.has_related_video?])
    # (It won't accept a bare false.)
    
    return solr_document
  end

  def thumbnail_url
    image_url
  end
  
  def image_url
    "https://s3.amazonaws.com/openvault.wgbh.org/images/#{original_file_name}" if original_file_name
  end
  
  def has_related_video?
    !!video
  end

  def title
    self.pbcore.image_title.first || "image"
  end

end
