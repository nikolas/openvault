class Audio < OpenvaultAsset
  has_many :transcripts, :property => :transcript_audio  
  has_many :images, :property => :image_audio
  belongs_to :program, :property => :audio_program
  belongs_to :series, :property => :series_audio
  
  def to_solr(solr_document={}, options={})
    super(solr_document, options)
    Solrizer.insert_field(solr_document, "audio_url", self.audio_url, :displayable)
    Solrizer.insert_field(solr_document, "audio_transcripts", self.audio_transcripts, :displayable)
    return solr_document
  end

  def titles_by_type
    @titles_by_type || self.pbcore.titles_by_type
  end
  
  def title
    titles_by_type['Item3'] || titles_by_type['Segment3'] || titles_by_type['Element3'] || titles_by_type['Clip'] || self.pbcore.asset_type.first
  end
 
  def audio_transcripts
    self.transcripts.map{ |t| t.pid }
  end
 
  def thumbnail_url
    # specific image lookup
    self.images.first.image_url unless self.images.empty?
  end

  def audio_url
    #This needs to change based on the decisions made about the streaming server
    #"http://media.wgbh.org/streaming/audios/#{self.id}.mp3"
    "#{media_host}/audio/#{original_file_name.sub(/\.[^.]+$/,'.mp3')}" if original_file_name
  end

end
