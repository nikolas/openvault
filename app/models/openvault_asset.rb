require 'hydra-pbcore'

class OpenvaultAsset < ActiveFedora::Base
  # belongs_to :artesia_ingest, :property => :is_part_of, :class_name => 'ArtesiaIngest'
  has_metadata 'uois', :type => Datastream::Uois
  # include Sufia::GenericFile
end