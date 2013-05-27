require 'artesia'

class Datastream::UOIS < ActiveFedora::OmDatastream

  include Artesia::Datastreams::UOIS

  set_terminology do |t|
    t.root(:path => "UOIS")
    add_uois_terminology t
  end

  class << self
    def xml_template
      Nokogiri::XML.parse("<UOIS/>")
    end  
  end
  
end