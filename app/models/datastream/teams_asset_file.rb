require 'artesia'

class Datastream::TeamsAssetFile < ActiveFedora::OmDatastream

  include Artesia::Datastreams::UOIS

  set_terminology do |t|

    t.root(:path => "TEAMS_ASSET_FILE")

    t.assets(:path => "ASSETS") {
      t.asset(:path => "ASSET") {
        t.metadata(:path => "METADATA") {
          t.uois(:path => "UOIS") {
            add_uois_terminology t  
          }
        }
        t.content(:path => "CONTENT")
      }
    }
  end

  class << self
    def xml_template
      Nokogiri::XML.parse("<TEAMS_ASSET_FILE/>")
    end  
  end
  
end