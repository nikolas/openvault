class Audio < OpenvaultAsset
  COVERAGE = ['complete', 'clip', 'segment']
  
  has_many :images, :property => :image_audio
  belongs_to :program, :property => :audio_program
  belongs_to :series, :property => :series_audio
  
  def to_solr(solr_document={}, options={})
    super(solr_document, options)
    Solrizer.insert_field(solr_document, "audio_url", self.audio_url, :displayable)
    Solrizer.insert_field(solr_document, "audio_images", self.audio_images, :displayable)
    return solr_document
  end
  
  def title
    self.pbcore.titles_by_type['Item3'] || self.pbcore.titles_by_type['Segment3'] || self.pbcore.titles_by_type['Element3']
  end
  
  def thumbnail_url
    # specific image lookup
    self.images.first.image_url unless self.images.empty?
  end

  def audio_url
    #This needs to change based on the decisions made about the streaming server
    #"http://media.wgbh.org/streaming/audios/#{self.id}.mp3"
    "#{media_host}/audio/#{original_file_name}" if original_file_name
  end
  
  def audio_images
    self.images.map{|i| i.id}
  end


  def relate_asset asset
    if asset.is_a? Image
      self.images += [Image]
    elsif asset.is_a? Program
      self.program = asset
    else
      super asset
    end
  end

  def original_file_name
    filename = ''
    for i in 0..pbcore.instantiations.count do
      instantiation = pbcore.instantiations(i)
      for j in 0..instantiation.id.count do
        instantiation_id = instantiation.id(j)
        if instantiation_id.source == ["Original file name"]
          filename = instantiation_id.first
        end
      end
    end
    filename
  end
  
end
