require 'openvault/pbcore'

namespace :openvault do
  desc "Ingest from pbcore xml file"
  task :ingest => :environment do |t, args|

    # Command line args:
    # +file+:: path to xml file

    policies = Openvault::Pbcore::Ingester::POLICIES
    raise ArgumentError, "USAGE: rake openvault:ingest file=[filename or glob] if_exists=[#{policies.join '|'}]" unless ENV['file']
    
    files = Dir[ENV['file']]
    files = Array(ENV['file']) if files.empty?

    # at the current time, we only ingest xml files
    files.select! {|file| (file =~ /\.xml$/) && !File.directory?(file) }

    # Set up the ingest logger here so we can log some messages before kicking passing the log to Ingester
    now = Time.new
    logger_output = ENV['log_file'] || "./log/openvault_ingest.#{now.strftime('%Y-%m-%d_%H%M%S%Z')}.log"
    logger = Logger.new(logger_output=='STDOUT' ? STDOUT : logger_output)
    logger.level = ENV['log_level'] || 1

    logger.info "Ingesting #{files.count} file(s)"

    files.each do |file|
      logger.info "Ingesting #{file}"
      xml = File.read(file)
      ingester = Openvault::Pbcore::Ingester.new(xml)
      # assign the logger to the Ingester effectively combines logs for all files being ingested.
      ingester.logger = logger
      ingester.policy = ENV['if_exists'].to_sym if ENV['if_exists']
      ingester.ingest
    end
    Rails.logger.info "\nIngest complete.\n"
  end
end
