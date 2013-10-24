class Program < OpenvaultAsset

  # belongs_to :series, :property => :is_program_of
  # has_many :videos, :property => :is_video_of
#   has_many :audios, :property => :is_audio_of
#   has_many :images, :property => :is_image_of
  
  def to_solr(solr_document={}, options={})
    super(solr_document, options)
    Solrizer.insert_field(solr_document, "videos", self.videos, :displayable, :searchable)
    Solrizer.insert_field(solr_document, "audios", self.audios, :displayable, :searchable)
    Solrizer.insert_field(solr_document, "images", self.images, :displayable, :searchable)
    return solr_document
  end


  def title
    self.pbcore.program_title
  end

  def videos
    #This will be an array of the pids build dynamically
    #self.videos.map{|v| v.pid}
    []
  end
  def audios
    #This will be an array of the pids build dynamically
    #self.audios.map{|v| v.pid}
    []
  end
  def images
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
end
