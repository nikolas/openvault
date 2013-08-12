require 'artesia/datastream/uois'
require 'openvault/datastream'

module Artesia
  module Datastream
    
    ##
    # Class Artesia::Datastream::TeamsAssetFile
    # Represents TEAMS_ASSET_FILE XML, generally a collection of UOIS assets.
    #
    class TeamsAssetFile < ActiveFedora::OmDatastream

      include Openvault::Datastream

      # Set the OM terminology.
      set_terminology do |t|

        t.root(:path => "TEAMS_ASSET_FILE")

        t.assets(:path => "ASSETS") {
          t.asset(:path => "ASSET") {
            t.metadata(:path => "METADATA") {
              t.uois(:path => "UOIS") {
                Artesia::Datastream::UOIS.add_uois_terminology t  
              }
            }
            t.content(:path => "CONTENT")
          }
        }
      end

      class << self
        # Returns a default xml doc for the datastream.
        # Required (or at least preferred) by ActiveFedora::OmDatastream
        def xml_template
          Nokogiri::XML.parse("<TEAMS_ASSET_FILE/>")
        end  
      end
    end
  end
end