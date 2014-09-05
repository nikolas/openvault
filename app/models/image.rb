#Should this belong to audio or video stream?
class Image < OpenvaultAsset
  include SharedMethods
  
  belongs_to :video, :property => :image_video
  belongs_to :program, :property => :image_program
  belongs_to :series, :property => :series_image # TODO: doesn't seem right.


  def relate_asset asset
    case asset
    when Video
      self.video = asset
    when Program
      self.program = asset
    when Series
      self.series = asset
    else
      super asset
    end
  end
  
  def to_solr(solr_document={}, options={})
    super(solr_document, options)
    Solrizer.insert_field(solr_document, "image_url", self.image_url, :displayable)
    return solr_document
  end

  def thumbnail_url
    image_url
  end
  
  def image_url
    "#{media_host}/images/#{original_file_name}" if original_file_name
  end

  def title
    self.pbcore.image_title.first || "image"
  end

end
