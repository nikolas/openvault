module Openvault::Pbcore
  class OpenvaultAssetFetcher

    attr_reader :pbcore_desc_doc

    def initialize(pbcore_desc_doc)
      @pbcore_desc_doc = pbcore_desc_doc
    end

    def openvault_asset(opts={})
      @af_model ||= (existing_openvault_asset || new_openvault_asset)
    end

    class MultipleOpenvaultAssetsFound < StandardError; end

    private

    def existing_openvault_asset
      ov_assets = ActiveFedora::Base.find({"all_ids_tesim" => pbcore_desc_doc.all_ids})
      raise MultipleOpenvaultAssetsFound, "#{ov_assets.count} records were found containing the pbcoreIdentifiers: #{pbcore_desc_doc.all_ids}" if ov_assets.count > 1
      ov_assets.first
    end

    def new_openvault_asset
      AssetClassifier.classify(@pbcore_desc_doc).new.tap do |af_model|
        af_model.pbcore.ng_xml = pbcore_desc_doc.ng_xml
      end
    end
  end
end