require 'openvault/ingester/pbcore'

module Openvault
  class Ingester
    class MARS

      @@tmp_dir = File.expand_path('../../../tmp/', __FILE__)

      @@tmp_file_prefix = "mars_ingest_tmp_"

      cattr_accessor :tmp_dir

      def self.ingest!(mars_table, args={})

        raise 'No input files or xml specified. Specify MARS input filenames with the :files option, or raw xml with the :xml option.' if (args[:files].nil? && args[:xml].nil?)

        input_files = Array.wrap(args[:files]) unless args[:files].nil?
        input_files |= self.write_tmp_files(args[:xml]) unless args[:xml].nil?

        # Return if nothing to do.
        return if input_files.empty?

        input_files.each do |input_file|
          ov_asset = OpenvaultAsset.new

          # Run the xslt translation to pbcore

          pbcore_xml = Openvault::MARS.to_pbcore(mars_table, input_file)

          # Not ingest using the PBCore ingester.
          Openvault::Ingester::Pbcore.ingest!(pbcore_xml, args[:depositor])
        end
      end

      def self.write_tmp_files(content)
        contents = Array.wrap(content)
        contents.map! do |c|
          File.write(self.next_tmp_file, content)
        end
      end

      def self.next_tmp_file
        i = 1
        next_file = "#{@@tmp_dir}/#{@@tmp_file_prefix}_#{i.to_s}"
        while File.exists? next_file
          next_file = "#{@@tmp_dir}/#{@@tmp_file_prefix}_#{i+=1.to_s}"
        end
        next_file
      end

      def self.delete_tmp_files(files)
        Dir["#{@@tmp_dir}/#{@@tmp_file_prefix}_*"].each {|tmp_file| File.delete(tmp_file)}
      end
    end
  end
end