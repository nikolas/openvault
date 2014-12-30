class Program < OpenvaultAsset

  belongs_to :series, :property => :series_program
  has_many :videos, :property => :video_program
  has_many :audios, :property => :audio_program
  has_many :images, :property => :program_image
  has_many :transcripts, :property => :transcript_program

  def to_solr(solr_document={}, options={})
    super(solr_document, options)
    Solrizer.insert_field(solr_document, "videos", self.all_videos, :displayable, :searchable)
    Solrizer.insert_field(solr_document, "video_count", self.videos.count, :displayable)
    Solrizer.insert_field(solr_document, "audios", self.all_audios, :displayable, :searchable)
    Solrizer.insert_field(solr_document, "audio_count", self.audios.count, :displayable)
    Solrizer.insert_field(solr_document, "images", self.all_images, :displayable, :searchable)
    Solrizer.insert_field(solr_document, "broadcast_date", self.broadcast_date, :stored_searchable, :dateable)
    return solr_document
  end

  def thumbnail_url
    # specific image lookup
  end

  def title
    self.pbcore.program_title.first
  end
  
  def episode
    self.pbcore.episode_title.first
  end
  
  def broadcast_date
    self.pbcore.broadcast_date.first
  end

  def all_videos
    self.videos.map{|v| v.pid}
  end
  def all_audios
    self.audios.map{|v| v.pid}
  end
  def all_images
    self.images.map{|v| v.pid}
  end
  def all_transcripts
    self.transcripts.map{|v| v.pid}
  end
  
end
