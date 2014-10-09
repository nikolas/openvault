module TranscriptsHelper
  def render_transcript(tei)
    document = Nokogiri::XML(tei.to_xml)
    template = Nokogiri::XSLT(File.read('lib/xslt/transcript_xml_to_html.xsl'))
    template.transform(document).to_s.html_safe
  end
end
