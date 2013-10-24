class OpenvaultAsset < ActiveFedora::Base
  include Blacklight::SolrHelper

  has_metadata 'pbcore', :type => PbcoreDescDoc
  
  def accept_annotations
    #logic will go here to accept annotations from scholars
  end
  
  def to_solr(solr_document={}, options={})
    super(solr_document, options)

    solr_document["slug"] = self.pid
    Solrizer.insert_field(solr_document, "title", self.title, :sortable, :displayable, :searchable)
    Solrizer.insert_field(solr_document, "summary", self.summary, :displayable, :searchable)
    return solr_document
  end


  # #title should be overridden in subclasses in most cases.
  # For the base class, we just grab the first title found in the pbcore datastream.
  def title
    self.pbcore.all_titles.first
  end

  def summary
    self.pbcore.summary
  end
  
end
