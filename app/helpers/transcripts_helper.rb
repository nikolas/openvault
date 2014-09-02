module TranscriptsHelper

  def transform_to_html(xml_doc)
    document = Nokogiri::XML(xml_doc)
    template = Nokogiri::XSLT(File.read('lib/xslt/transcript_xml_to_html.xsl'))
    
    transformed_doc = template.transform(document)
    return transformed_doc
  end
end
