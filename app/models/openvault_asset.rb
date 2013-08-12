require 'hydra-pbcore'
require 'artesia/datastream/uois'

class OpenvaultAsset < ActiveFedora::Base

  has_metadata 'uois', :type => Artesia::Datastream::UOIS
  has_metadata 'pbcore', :type => HydraPbcore::Datastream::Document
  belongs_to :artesia_ingest, :property => :is_part_of, :class_name => 'ArtesiaIngest'
  
  include Sufia::GenericFile
  
  def to_solr(solr_document={}, options={})
    super(solr_document, options)
    #solr_document["the_title"] = "testing"
    return solr_document
  end
end