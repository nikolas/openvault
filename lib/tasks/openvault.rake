namespace :openvault do

  desc "Ingest from pbcore xml file"
  task :ingest => :environment do

    require 'openvault/pbcore'
  
    # Command line args:
    # +file+:: path to xml file
  

    # Open logger for logging output.
    Rails.logger = Logger.new(STDOUT)
    Rails.logger.level = 0

    # Check for required arguments:
    # +file+ full path of the file to ingest.
    # Require +file+ argument
    Rails.logger.warning "USAGE: rake openvault:ingest file=[file]" unless ENV['file']

    xml = File.read(ENV['file'])

    Openvault::Pbcore.ingest!(xml)
  end
end