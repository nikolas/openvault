require 'hydra-pbcore'
require 'artesia/datastream/uois'

class OpenvaultAsset < ActiveFedora::Base
  include Blacklight::SolrHelper

  has_metadata 'uois', :type => Artesia::Datastream::UOIS
  has_metadata 'pbcore', :type => HydraPbcore::Datastream::Document

  has_file_datastream 'source_xml'

  belongs_to :artesia_ingest, :property => :is_part_of, :class_name => 'ArtesiaIngest'
  
  #don't think this is working
  has_many :custom_collection_items, :property => :is_part_of
  
  include Sufia::GenericFile
  
  def accept_annotations
    #logic will go here to accept annotations from scholars
  end
  
  def to_solr(solr_document={}, options={})
    super(solr_document, options)
    solr_document["slug"] = self.noid
    Solrizer.insert_field(solr_document, "sort_date", self.pbcore.asset_date.first, :sortable)
    Solrizer.insert_field(solr_document, "sort_title", self.pbcore.title.first, :sortable)
    return solr_document
  end
  
end
