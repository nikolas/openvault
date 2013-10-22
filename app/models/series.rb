class Series < OpenvaultAsset
  # attr_accessible :title, :body
  has_many :programs, :property => :series_program
  
  # metadata for Series
  #     - dates / date ranges (e.g. when it aired)
  #     - producer info
  
  def to_solr(solr_document={}, options={})
    super(solr_document, options)
    Solrizer.insert_field(solr_document, "programs", self.all_programs, :displayable, :searchable)
    return solr_document
  end
  
  
  def title
    #need logic to determine proper title
    "This is a series title #{self.id}"
  end
  
  def all_programs
    #This will be an array of the pids build dynamically
    ['s7526p520', 's7526p51q', 's7526p474']
  end
  
end
