#Should this belong to audio or video stream?
class Image < OpenvaultAsset
  
  belongs_to :video, :property => :image_video
  belongs_to :audio, :property => :image_audio
  belongs_to :series, :property => :series_image


  def relate_asset asset
    if asset.is_a? Video
      self.video = asset
    elsif asset.is_a? Audio
      self.audio = asset
    else
      super asset
    end
  end
  
  def to_solr(solr_document={}, options={})
    super(solr_document, options)
    Solrizer.insert_field(solr_document, "image_path", self.image_file, :displayable)
    return solr_document
  end
  
  def image_file
    "#{media_host}/images/#{original_file_name}"
  end

  def title
    self.pbcore.image_title.first || "image"
  end

  def original_file_name
    for i in 0..pbcore.instantiations.count do
      instantiation = pbcore.instantiations(i)
      for j in 0..instantiation.id.count do
        instantiation_id = instantiation.id(j)
        if instantiation_id.source == ["Original file name"]
          return instantiation_id
        end
      end
    end
  end
  
end