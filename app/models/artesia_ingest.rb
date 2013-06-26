class ArtesiaIngest < ActiveFedora::Base
  has_metadata 'teams_asset_file', :type => Datastream::TeamsAssetFile
  has_many :openvault_assets, :property => :is_part_of, :inbound => true, :class_name => 'OpenvaultAsset'

  attr_accessor :depositor

  def apply_teams_asset_file(teams_asset_file)
    self.teams_asset_file.set_xml teams_asset_file
    self.generate_openvault_assets
    self.relate_openvault_assets
  end

  # Saves the ArtesiaIngest and all OpenvaultAsset in #openvault_assets
  def save_all!
    self.openvault_assets.each do |ov_asset|
      ov_asset.apply_depositor_metadata self.depositor unless ov_asset.depositor
      ov_asset.save!
    end
    self.save!
  end


  protected

  def generate_openvault_assets
    self.openvault_assets = []
    # NOTE: This '#find_by_terms' business is similar to xpath //assets/asset/metadata/uois
    self.teams_asset_file.find_by_terms(:assets, :asset, :metadata, :uois).each do |ng_xml|

      ov_asset = OpenvaultAsset.new
      ov_asset.uois.set_xml ng_xml.to_xml
      ov_asset.apply_depositor_metadata self.depositor

      # Add the OpenvaultAsset to the ArtesiaIngest.
      # Note that because the ArtesiaIngest instance is already saved,
      # it will try to save the OpenvaultAsset when it is added to the 'openvault_assets' array.
      self.openvault_assets << ov_asset
    end
  end

  def relate_openvault_assets
    # named_entities_x_uoi_ids = teams_asset_file.to_xml.scan(/<!ENTITY (linkedAsset[\d]+) SYSTEM "teams:\/query-uoi\?uois:uoi_id:eq:([^"]+)" NDATA teams_query>/)

  end

  def apply_depositor_metadata(overwrite=false)
    self.openvault_assets.each do |ov_asset|
      if overwrite.depositor.nil? || overwrite
        ov_asset.apply_depositor_metadata self.depositor unless ov_asset.depositor && !overwrite
      end
    end
  end

end