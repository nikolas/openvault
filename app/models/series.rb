class Series < OpenvaultAsset
  # attr_accessible :title, :body
  has_many :programs, :property => :series_program
  has_many :videos, :property => :series_video
  has_many :audios, :property => :series_audio
  has_many :images, :property => :series_image
  has_many :transcripts, :property => :series_transcript
  
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
  
  
  def title
    self.pbcore.series_title
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
    if asset.is_a? Program
      self.programs << asset
    elsif asset.is_a? Video
      self.videos << asset
    elsif asset.is_a? Audio
      self.audios << asset
    elsif asset.is_a? Image
      self.images << asset
    elsif asset.is_a? Transcript
      self.transcripts << asset
    elsif asset.is_a? OpenvaultAsset
      nil
    else
      super asset
    end
  end
  
end
