module Openvault
  class TranscriptIngester
    def self.ingest_tei_xml_specified_by_pbcore(transcript_model, path_to_tei_xml)
      tei_xml_filename = File.join(path_to_tei_xml, transcript_model.original_file_name)
      tei_xml = Openvault::XML(File.read(tei_xml_filename))
      transcript_model.tei.ng_xml = tei_xml
      transcript_model.save!
    end 
  end
end