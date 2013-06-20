class ArtesiaIngest < ActiveFedora::Base
  has_metadata 'teams_asset_file', :type => Datastream::TeamsAssetFile
  has_many :openvault_assets, :property => :is_part_of, :inbound => true, :class_name => 'OpenvaultAsset'

  attr_accessor :depositor

  # Saves all chilren as OpenvaultAssets, and sets their relationships.
  def save_all!
    self.save!
    self.teams_asset_file.find_by_terms(:assets, :asset, :metadata, :uois).each do |ng_xml|

      ov_asset = OpenvaultAsset.new
      # Set xml for UOIS datastream of OpenvaultAsset using xml= method.
      # Note: OpenvaultAsset#xml= re-parses the XML using Nokogiri::XML
      ov_asset.uois.set_xml ng_xml.to_xml
      ov_asset.apply_depositor_metadata self.depositor
      ov_asset.save!

      # Add the OpenvaultAsset to the ArtesiaIngest.
      # Note that because the ArtesiaIngest instance is already saved,
      # it will try to save the OpenvaultAsset when it is added to the 'openvault_assets' array.
      self.openvault_assets << ov_asset
    end
  end
end