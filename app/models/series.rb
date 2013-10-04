class Series < OpenvaultAsset
  # attr_accessible :title, :body
  has_many :programs, :property => :is_program_of
  
  # def self.model_name
  #   OpenvaultAsset.model_name
  # end
  
  # metadata for Series
  #     - dates / date ranges (e.g. when it aired)
  #     - producer info
  
  def to_solr(solr_document={}, options={})
    super(solr_document, options)
    solr_document["slug"] = self.noid
    Solrizer.insert_field(solr_document, "sort_date", self.pbcore.asset_date.first, :sortable)
    Solrizer.insert_field(solr_document, "sort_title", self.pbcore.title.first, :sortable)
    Solrizer.insert_field(solr_document, "display_title", self.title, :sortable, :displayable, :searchable)
    Solrizer.insert_field(solr_document, "display_summary", self.summary, :displayable, :searchable)
    Solrizer.insert_field(solr_document, "programs", self.programs, :displayable, :searchable)
    return solr_document
  end
  
  
  def title
    #need logic to determine proper title
    "blah"
  end
  
  def programs
    #This will be an array of the pids build dynamically
    ['s7526p520', 's7526p51q', 's7526p474']
  end
  
end
