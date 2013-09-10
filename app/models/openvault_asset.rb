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
  
  def to_solr(solr_document={}, options={})
    super(solr_document, options)
    #solr_document["the_title"] = "testing"
    return solr_document
  end
  
  def accept_annotations
    #logic will go here to accept annotations from scholars
  end
  
  def to_solr(solr_document={}, options={})
    super(solr_document, options)
    solr_document["slug"] = self.slugify_doc
    #Solrizer.insert_field(solr_document, "collection_ancestry", "Collection 2", :facetable, :searchable, :displayable)
    return solr_document
  end
  
  protected
  
  def slugify_doc
    pbcore = self.pbcore
    slug = ''
    
    if pbcore.title.first.nil?
      slug = ("#{pbcore.series.first} #{pbcore.program.first} #{pbcore.episode.first}").parameterize
    else
      slug = pbcore.title.first.parameterize
    end
    slug_check = OpenvaultAsset.find(:slug => slug)
    (slug_check.empty?) ? slug : "#{slug}-#{self.noid}"
  end
end
