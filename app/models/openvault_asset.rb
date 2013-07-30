require 'hydra-pbcore'

class OpenvaultAsset < ActiveFedora::Base

  has_metadata 'uois', :type => Datastream::UOIS
  has_metadata 'pbcore', :type => HydraPbcore::Datastream::Document
  belongs_to :artesia_ingest, :property => :is_part_of, :class_name => 'ArtesiaIngest'
  
  include Sufia::GenericFile
end