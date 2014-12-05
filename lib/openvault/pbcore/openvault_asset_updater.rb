module Openvault::Pbcore
  class OpenvaultAssetUpdater

    attr_reader :pbcore_desc_doc

    def initialize(pbcore_desc_doc)
      @pbcore_desc_doc = pbcore_desc_doc
    end

    def updated_openvault_asset
      if !@updated
        @updated = requires_reclassification? ? create_new_openvault_asset : existing_openvault_asset
        @updated.pbcore.ng_xml = pbcore_desc_doc.ng_xml
      end
      @updated
    end

    def existing_openvault_asset
      @existing ||= fetch_existing_openvault_asset
    end

    class MultipleOpenvaultAssetsFound < StandardError; end

    private

    def existing_classification
      AssetClassifier.classify(existing_openvault_asset.pbcore) if existing_openvault_asset
    end

    def updated_classification
      AssetClassifier.classify(@pbcore_desc_doc)
    end

    def requires_reclassification?
      existing_classification != updated_classification
    end

    def fetch_existing_openvault_asset
      ov_assets = ActiveFedora::Base.find({"all_ids_ssim" => pbcore_desc_doc.all_ids})
      raise MultipleOpenvaultAssetsFound, "#{ov_assets.count} records were found containing the pbcoreIdentifiers: #{pbcore_desc_doc.all_ids}" if ov_assets.count > 1
      ov_assets.first
    end

    def create_new_openvault_asset
      updated_classification.new.tap do |ov_asset|
        ov_asset.pbcore.ng_xml = pbcore_desc_doc.ng_xml
      end
    end
  end
end