require 'hydra-pbcore'

class OpenvaultAsset < ActiveFedora::Base
  include Blacklight::SolrHelper

  has_metadata 'uois', :type => Datastream::UOIS
  has_metadata 'pbcore', :type => HydraPbcore::Datastream::Document
  belongs_to :artesia_ingest, :property => :is_part_of, :class_name => 'ArtesiaIngest'
  
  #don't think this is working
  has_many :custom_collection_items, :property => :is_part_of
  
  include Sufia::GenericFile
  
  def accept_annotations
    #logic will go here to accept annotations from scholars
  end
  
  def to_solr(solr_document={}, options={})
    super(solr_document, options)
    solr_document["slug"] = self.slugify_doc
    return solr_document
  end
  
  protected
  
  def slugify_doc
    pbcore = self.pbcore
    slug = ''
    
    if pbcore.title_clip.first.nil?
      slug = ("#{pbcore.series.first} #{pbcore.title.first} #{pbcore.episode.first}").parameterize
    else
      slug = pbcore.title_clip.first.parameterize
    end
    slug_check = OpenvaultAsset.find(:slug => slug)
    (slug_check.empty?) ? slug : "#{slug}-#{self.noid}"
  end
end