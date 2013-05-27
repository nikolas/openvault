class ArtesiaIngest < ActiveFedora::Base
  has_metadata 'teams_asset_file', :type => Datastream::TeamsAssetFile
  has_many :openvault_assets, :property => :is_part_of, :inbound => true, :class_name => 'OpenvaultAsset'
end