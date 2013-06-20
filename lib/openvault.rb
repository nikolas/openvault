module Openvault
  module Ingester
    module Artesia
      def self.ingest!(teams_asset_file, depositor)
        artesia_ingest = ArtesiaIngest.new
        artesia_ingest.teams_asset_file.set_xml teams_asset_file
        artesia_ingest.depositor = depositor
        artesia_ingest.save_all!
      end
    end
  end
end