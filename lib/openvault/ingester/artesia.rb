module Openvault
  class Ingester
    class Artesia
      def self.ingest!(teams_asset_file, depositor)
        artesia_ingest = ArtesiaIngest.new
        artesia_ingest.apply_teams_asset_file teams_asset_file
        artesia_ingest.depositor = depositor
        artesia_ingest.save_all!
      end
    end
  end
end