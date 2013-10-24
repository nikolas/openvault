class Video < OpenvaultAsset
  
  COVERAGE = ['complete', 'clip', 'segment']
  
  has_many :transcripts, :property => :transcript_video
  has_many :images, :property => :image_video
  belongs_to :program, :property => :video_program
  
  def to_solr(solr_document={}, options={})
    super(solr_document, options)
    Solrizer.insert_field(solr_document, "program_id", self.program.pid, :displayable)
    Solrizer.insert_field(solr_document, "video_url", self.video_url, :displayable)
    Solrizer.insert_field(solr_document, "video_images", self.video_images, :displayable)
    Solrizer.insert_field(solr_document, "video_transcript", self.video_transcripts, :displayable)
    return solr_document
  end
  
  def title
    "This is a video title #{self.pid}"
  end
  
  def video_url
    #This needs to change based on the decisions made about the streaming server
    "http://media.wgbh.org/streaming/videos/#{self.pid}.mp4"
  end
  
  def video_transcripts
    self.transcripts.map{|t| t.id}
  end
  
  def video_images
    self.images.map{|i| i.id}
    # This will be an array of the image ids for the video
    []
  end
  
  #Video Metadata
  # - Length
  # - People involved
  # - formats
end