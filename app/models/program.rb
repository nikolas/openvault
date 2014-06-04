class Program < OpenvaultAsset

  belongs_to :series, :property => :series_program
  has_many :videos, :property => :video_program
  has_many :audios, :property => :audio_program

  def to_solr(solr_document={}, options={})
    super(solr_document, options)
    Solrizer.insert_field(solr_document, "videos", self.all_videos, :displayable, :searchable)
    Solrizer.insert_field(solr_document, "audios", self.all_audios, :displayable, :searchable)
    Solrizer.insert_field(solr_document, "images", self.all_images, :displayable, :searchable)
    Solrizer.insert_field(solr_document, "asset_count", self.asset_count, :displayable, :searchable)
    return solr_document
  end

  def thumbnail_url
    # specific image lookup
  end

  def title
    self.pbcore.program_title.first
  end

  def asset_count
    self.videos.count + self.audios.count
  end

  def all_videos
    #This will be an array of the pids build dynamically
    self.videos.map{|v| v.pid}
  end
  def all_audios
    #This will be an array of the pids build dynamically
    self.audios.map{|v| v.pid}
  end
  def all_images
    #This will be an array of the pids build dynamically
    #self.images.map{|v| v.pid}
    []
  end

  # metadata for Program
  #     - episodic info
  #     - segment info (e.g. "part 1 of 3")
  #     - dates (e.g. when it aired)
  #     - producer info
  #     - people involved (e.g. interviewees, talent, etc)
  #     - copyright info

  def relate_asset asset
    if asset.is_a? Series
      self.series = asset
    elsif asset.is_a? Video
      self.videos << asset
    elsif asset.is_a? Audio
      self.audios << asset
    elsif asset.is_a? OpenvaultAsset
      nil
    else
      super asset
    end
  end
end
