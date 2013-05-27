class ArtesiaIngest < ActiveFedora::Base

  has_metadata 'teams_asset_file', :type => Datastream::TeamsAssetFile

  has_many :openvault_assets, :property => :is_part_of, :inbound => true, :class_name => 'OpenvaultAsset'

  # Parse the xml file with Nokogiri, using the +noblanks+ and +strict+ options,
  # Assign resulting xml to content of input_file datastream.
  # Set mime-type of input_file datastream to "text/xml"
  # +file+:: readable File object.
  # def attach_input_file(file)
  #   file.rewind
  #   input_file.content = self.class.ng_xml(file.read).to_xml
  #   input_file.mimeType = 'text/xml'
  # end

  # def run!
  #   ng_xml = self.class.ng_xml input_file.content
  #   uois_xml_nodes = ng_xml.xpath('//TEAMS_ASSET_FILE/ASSETS/ASSET/METADATA/UOIS')
  #   raise "there aint no assets dude!!!" unless uois_xml_nodes.count > 0
  #   uois_xml_nodes.each do |uois|
  #     ov_asset = OpenvaultAsset.new
  #     ov_asset.uois.ng_xml = ng_xml
  #     ov_asset.save!
  #   end
  # end


  # class << self
  #   def ng_xml str
  #     Nokogiri::XML(str) { |config| config.noblanks.strict }
  #   end
  # end

end