class Video < OpenvaultAsset
  
  COVERAGE = ['complete', 'clip', 'segment']
  
  has_many :transcripts, :property => :transcript_video
  has_many :images, :property => :image_video
  belongs_to :program, :property => :video_program
  
  def to_solr(solr_document={}, options={})
    super(solr_document, options)
    Solrizer.insert_field(solr_document, "program_noid", self.parent_program, :displayable)
    Solrizer.insert_field(solr_document, "video_url", self.video_url, :displayable)
    Solrizer.insert_field(solr_document, "video_images", self.video_images, :displayable)
    Solrizer.insert_field(solr_document, "video_transcript", self.video_transcripts, :displayable)
    return solr_document
  end
  
  def title
    "This is a video title #{self.noid}"
  end
  
  def parent_program
    self.program.first.noid
  end
  
  def video_url
    #This needs to change based on the decisions made about the streaming server
    "http://media.wgbh.org/streaming/videos/#{self.noid}.mp4"
  end
  
  def video_transcripts
    self.transcripts.map{|t| t.id}
  end
  
  def video_images
    # This will be an array of the image noids for the video
    #[]
    self.images.map{|i| i.id}
  end
  
  #Video Metadata
  # - Length
  # - People involved
  # - formats
end