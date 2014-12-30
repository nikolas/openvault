module Openvault
  class TranscriptIngester

    @@logger=Logger.new(STDOUT)

    # Looks for file specified by Transcript#original_file_name, loads it into the TeiDatastream for the Transcript model, and saves the Transcript model along the the datastream.
    def self.ingest_tei_xml_specified_by_pbcore!(transcript_model, path_to_tei_xml)
      tei_xml_filename = File.join(path_to_tei_xml, transcript_model.original_file_name.to_s)
      tei_xml = Openvault::XML(File.read(tei_xml_filename))
      transcript_model.tei.ng_xml = tei_xml
      transcript_model.save!
    end

    # Rescues from exceptions thrown by .ingest_tei_xml_specification_by_pbcore, logs them, and continues execution.
    def self.ingest_tei_xml_specified_by_pbcore(transcript_model, path_to_tei_xml)
      self.ingest_tei_xml_specified_by_pbcore!(transcript_model, path_to_tei_xml)
    rescue => e
      @@logger.error("\nUnable to ingest TEI xml specified by pbcore for Transcript with pid='#{transcript_model.pid}', pbcoreIdentifiers = '#{transcript_model.pbcore.all_ids}', and original file name = '#{transcript_model.original_file_name}'. Looking for TEI xml file in '#{path_to_tei_xml}'.")
      @@logger.error(e.message)
      return false
    end

    # Allows you to set a logger as a class variable. Probably not threadsafe, but we're not worrying about that now.
    def self.logger=(logger)
      raise(ArgumentError, "First argument must be an instance of Logger, but #{logger.class} was given") unless logger.is_a? Logger
      @@logger = logger
    end
  end
end