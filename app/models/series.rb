class Series < OpenvaultAsset
  # attr_accessible :title, :body
  has_many :programs, :property => :series_program
  has_many :videos, :property => :series_video
  has_many :audios, :property => :series_audio
  has_many :images, :property => :series_image
 
  
  # metadata for Series
  #     - dates / date ranges (e.g. when it aired)
  #     - producer info
  
  def to_solr(solr_document={}, options={})
    super(solr_document, options)
    Solrizer.insert_field(solr_document, "programs", self.all_programs, :displayable, :searchable)
    Solrizer.insert_field(solr_document, "videos", self.all_videos, :displayable, :searchable)
    Solrizer.insert_field(solr_document, "images", self.all_images, :displayable, :searchable)
    return solr_document
  end

  def thumbnail_url
    # specific image lookup
    img = self.images.first.image_url unless self.images.empty?
    img ||= thumbnail_url_fallback
    return img
  end
  
  def thumbnail_url_fallback
    img = programs.first.thumbnail_url unless programs.empty?
    img ||= videos.first.thumbnail_url unless videos.empty?
    return img
  end

  def title
    self.pbcore.series_title.first
  end
  
  def all_programs
    self.programs.map{|s| s.pid }
  end
  
  def all_videos
    self.videos.map{|s| s.pid }
  end
  
  def all_images
    self.images.map{|s| s.pid }
  end

  def relate_asset asset
    case asset
    when Program
      self.programs << asset
    when Video
      self.videos << asset
    when Audio
      self.audios << asset
    when Image
      self.images << asset
    else
      super asset
    end
  end
  
end
