require 'openvault/pbcore'

namespace :openvault do
  desc "Ingest from pbcore xml file"
  task :ingest => :environment do |t, args|
  
    # Command line args:
    # +file+:: path to xml file
  

    # Open logger for logging output.
    Rails.logger = Logger.new(STDOUT)
    Rails.logger.level = 0

    raise ArgumentError, "USAGE: rake openvault:ingest file=[filename or glob]" unless ENV['file']

    files = Dir[ENV['file']]
    files = Array(ENV['file']) if files.empty? 

    # at the current time, we only ingest xml files
    files.select! {|file| (file =~ /\.xml$/) && !File.directory?(file) }

    Rails.logger.info "Ingesting #{files.count} file(s)"

    files.each do |file|
      Rails.logger.info "Ingesting #{file}"
      xml = File.read(file)
      Openvault::Pbcore::Ingester.new(xml).ingest
    end
    Rails.logger.info "\nIngest complete.\n"
  end
end
