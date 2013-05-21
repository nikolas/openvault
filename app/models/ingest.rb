class Ingest < ActiveFedora::Base

  has_file_datastream 'input_file'

  # Parse the xml file with Nokogiri, using the +noblanks+ and +strict+ options,
  # Assign resulting xml to content of input_file datastream.
  # Set mime-type of input_file datastream to "text/xml"
  # +file+:: readable File object.
  def attach_input_file(file)
    ng_xml = self.class.ng_xml file.read
    input_file.content  = ng_xml.to_xml
    input_file.mimeType = 'text/xml'
  end

  def run!
    raise "There is no input file to process. Attach input file with #{self.class}#attach_input_file" if input_file.content.nil?
  end

  class << self
    def ng_xml str
      Nokogiri::XML(str) { |config| config.noblanks.strict }
    end
  end

end