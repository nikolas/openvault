require 'hydra-pbcore'

class OpenvaultAsset < ActiveFedora::Base

  has_metadata 'uois', :type => Datastream::UOIS
  has_metadata 'pbcore', :type => HydraPbcore::Datastream::Document
  belongs_to :artesia_ingest, :property => :is_part_of, :class_name => 'ArtesiaIngest'
  
  #don't think this is working
  has_many :custom_collection_items, :property => :is_part_of
  
  include Sufia::GenericFile
  
  def accept_annotations
    #logic will go here to accept annotations from scholars
  end
end