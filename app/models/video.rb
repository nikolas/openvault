class Video < OpenvaultAsset
  include PbcoreAccessors

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
    Solrizer.insert_field(solr_document, "video_transcripts", self.video_transcripts, :displayable)
    Solrizer.insert_field(solr_document, "series", self.series.title, :facetable) if self.series
    return solr_document
  end

  def titles_by_type
    @titles_by_type || self.pbcore.titles_by_type
  end

  def title
    titles_by_type['Element2'] || 
      titles_by_type['Element3'] || 
      titles_by_type['Item2'] || 
      titles_by_type['Clip'] ||
      titles_by_type['Program'] ||
      self.pbcore.asset_type.first
  end

  # Returns the video URL
  #   opts[:format] - a string to use to override the file extension in the URL, e.g. "mp4"
  def video_url(opts={})
    if original_file_name
      file = opts[:format].nil? ? original_file_name : original_file_name.sub(/\.[^.]+$/, ".#{opts[:format].to_s}")
      "#{media_host}/video/#{file}"
    end
  end

  def video_transcripts
    self.transcripts.map{|t| t.pid}
  end

  def video_images
    self.images.map{|i| i.pid}
  end

  def thumbnail_url
    self.images.first.image_url unless self.images.empty?
  end

  def login_required?
    self.rights_holder == 'CBS News'
  end
  
end
