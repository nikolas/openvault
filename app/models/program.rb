class Program < OpenvaultAsset

  belongs_to :series, :property => :is_program_of
  # has_many :videos, :property => :is_video_of
#   has_many :audios, :property => :is_audio_of
#   has_many :images, :property => :is_image_of
  
  def to_solr(solr_document={}, options={})
    super(solr_document, options)
    solr_document["slug"] = self.noid
    Solrizer.insert_field(solr_document, "sort_date", self.pbcore.asset_date.first, :sortable)
    Solrizer.insert_field(solr_document, "sort_title", self.pbcore.title.first, :sortable)
    Solrizer.insert_field(solr_document, "display_title", self.title, :sortable, :displayable, :searchable)
    Solrizer.insert_field(solr_document, "display_summary", self.summary, :displayable, :searchable)
    Solrizer.insert_field(solr_document, "videos", self.all_videos, :displayable, :searchable)
    Solrizer.insert_field(solr_document, "audios", self.all_audios, :displayable, :searchable)
    Solrizer.insert_field(solr_document, "images", self.all_images, :displayable, :searchable)
    return solr_document
  end


  def title
    #need logic to determine proper title
    "This is a Program sample title #{self.id}"
  end

  def all_videos
    #This will be an array of the pids build dynamically
    #self.videos.map{|v| v.pid}
    ['37720c723']
  end
  def all_audios
    #This will be an array of the pids build dynamically
    #self.audios.map{|v| v.pid}
    ['37720c73c']
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
end
