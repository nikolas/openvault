module Openvault::Pbcore
  class AssetRelationshipBuilder
    attr_accessor :asset

    def initialize(asset=nil)
      @asset = asset
    end

    def pbcore
      asset.pbcore
    end

    # Uses pbcore.relations_by_type to establish ActiveFedora relations with existing fedora objects.
    # NOTE: This method assumes:
    #   * Two records are related when a value within one record's <pbcoreIdentifier> node is present in another's <pbcoreRelationIdentifier> node
    #   * There is only one <pbcoreRelationIdentifier> per <pbcoreRelation>
    def relate
      if !pbcore.relations_by_type.empty?
        pbcore.relations_by_type.each do |relation_type, pbcore_ids|        # For each relation type, there is a list of values from <pbcoreRelationIdentifier> nodes, that we will call pbcore_ids
          pbcore_ids.each do |pbcore_id|
            related_assets = ActiveFedora::Base.find({:all_ids_tesim => pbcore_id})

            related_assets.each do |related_asset|
              asset.relate_asset related_asset
              asset.save!
            end
          end
        end
      end
    end
  end
end
