namespace :openvault do

  namespace :ingest do
    
    # Command line args:
    # +file+:: path to xml file
    desc "Ingest assets from Artesia XML into Fedora"
    task :artesia => :environment do
      require 'openvault/ingester/artesia'

      # Open logger for logging output.
      Rails.logger = Logger.new(STDOUT)
      Rails.logger.level = 0

      # Check for required arguments:
      # +file+ full path of the file to ingest.
      # Require +file+ argument
      Rails.logger.warning "USAGE: rake openvault:ingest file=[file]" unless ENV['file']

      xml = File.read(ENV['file'])

      Openvault::Ingester::Artesia.ingest!(xml, 'from rake task')
    end
  end
end