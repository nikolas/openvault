class Video < OpenvaultAsset
  
  COVERAGE = ['complete', 'clip', 'segment']
  
  has_many :transcripts, :property => :transcript_video
  has_many :images, :property => :image_video
  belongs_to :program, :property => :video_program
  belongs_to :series, :property => :video_series
  
  def to_solr(solr_document={}, options={})
    super(solr_document, options)
    Solrizer.insert_field(solr_document, "program_id", self.program.pid, :displayable) unless self.program.nil?
    Solrizer.insert_field(solr_document, "video_url", self.video_url, :displayable)
    Solrizer.insert_field(solr_document, "video_images", self.video_images, :displayable)
    Solrizer.insert_field(solr_document, "video_transcript", self.video_transcripts, :displayable)
    return solr_document
  end
  
  def title
    self.pbcore.titles_by_type['Element2'] || self.pbcore.titles_by_type['Element3'] || self.pbcore.asset_type
  end
  
  def video_url
    #This needs to change based on the decisions made about the streaming server
    "http://media.wgbh.org/streaming/videos/#{self.pid}.mp4"
  end
  
  def video_transcripts
    self.transcripts.map{|t| t.pid}
  end
  
  def video_images
    self.images.map{|i| i.pid}
  end

  def thumbnail_url

    self.images.first.image_url unless (self.images.empty? || self.images.first.image_url.nil?)
  end
  
  #Video Metadata
  # - Length
  # - People involved
  # - formats


  def relate_asset asset
    if asset.is_a? Image
      self.images << asset
    elsif asset.is_a? Program
      self.program = asset
    elsif asset.is_a? Transcript
      self.transcripts << asset
    elsif asset.is_a? Series
      self.series = asset
    elsif asset.is_a? OpenvaultAsset
      nil
    else
      super asset
    end
  end
end