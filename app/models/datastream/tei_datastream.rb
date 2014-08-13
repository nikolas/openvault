class TeiDatastream < ActiveFedora::OmDatastream
  def self.xml_template
    # default template required by OmDatasream
    Nokogiri::XML('<TEI xmlns="http://www.tei-c.org/ns/1.0" xmlns:xhtml="http://www.w3.org/1999/xhtml" />')
  end
end