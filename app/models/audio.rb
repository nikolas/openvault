class Audio < OpenvaultAsset
  COVERAGE = ['complete', 'clip', 'segment']
  
  has_many :images, :property => :image_audio
  belongs_to :program, :property => :audio_program
  
  def to_solr(solr_document={}, options={})
    super(solr_document, options)
    solr_document["slug"] = self.noid
    Solrizer.insert_field(solr_document, "sort_date", self.pbcore.asset_date.first, :sortable)
    Solrizer.insert_field(solr_document, "sort_title", self.pbcore.title.first, :sortable)
    Solrizer.insert_field(solr_document, "display_title", self.title, :sortable, :displayable, :searchable)
    Solrizer.insert_field(solr_document, "display_summary", self.summary, :displayable, :searchable)
    Solrizer.insert_field(solr_document, "audio_url", self.audio_url, :displayable)
    Solrizer.insert_field(solr_document, "audio_images", self.audio_images, :displayable)
    return solr_document
  end
  
  def title
    "This is an audio file title #{self.noid}"
  end
  
  def audio_url
    #This needs to change based on the decisions made about the streaming server
    "http://media.wgbh.org/streaming/audios/#{self.noid}.jpg"
  end
  
  def audio_images
    []
  end
  
end