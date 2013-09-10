require 'openvault/mars'
require 'openvault/ingester/pbcore'

module Openvault
  class Ingester
    class MARS

      INGEST_RETURN_OPTIONS = [:count, :objects, :pids]

      @@tmp_dir = File.expand_path('../mars/tmp/', __FILE__)

      @@ingest_threads = 9
      @@ingest_return = :count

      cattr_accessor :tmp_dir, :ingest_threads, :ingest_return


      # overwrite class attr writer for @@tmp_dir to verify it's a writable directory
      def self.tmp_dir=(dirname)
        raise "Cannot set tmp_dir to #{dirname}, it's not a directory" unless File.directory? dirname
        @@tmp_dir = dirname
      end

      def self.ingest_threads=(threads)
        raise 'Invalid value for ingest_threads=, valid value must have #to_i method' unless threads.respond_to? :to_i
        @@ingest_threads = threads.to_i
      end

      def self.ingest_return=(return_opt)
        raise "Invalid value for ingest_return=, valid values are :#{INGEST_RETURN_OPTIONS.join(', :')}" unless INGEST_RETURN_OPTIONS.include? return_opt
        @@ingest_return = return_opt
      end

      # .ingest!
      # Ingests OpenvaultAsset models from MARS (Filemaker) xml, creating a PBCore and saving the source xml from MARS.
      # Saving the MARS xml to a datastream requires isolating MARS records into their own files because translation from
      # MARS to PBCore uses a shell command that operates on files (see Openvault::MARS.to_pbcore).
      # So that is why there is the bit about .write_mars_record_files.
      # A better way would be to modify Openvualt::MARS.to_pbcore to run the translation without requiring a file
      # present on the filesystem. #TODO.
      def self.ingest!(mars_table, args)

        raise 'No input files specified. Specify MARS input filenames with the :files option.' if args[:files].nil?
        raise 'No depositor specified. Specify depositor with the :depositor option' if args[:depositor].nil?

        self.ingest_threads = args[:threads] unless args[:threads].nil?
        self.ingest_return = args[:return] unless args[:return].nil?

        
        input_files = Array.wrap(args[:files])

        # Return if nothing to do.
        return if input_files.empty?

        # initialize the return value based on the :return option
        return_val = case self.ingest_return
          when :count
            0
          when :objects
            []
          when :pids
            []
        end




        # Slice the `input_files` array into batches of size `threads`
        until (batch = input_files.slice!(0, self.ingest_threads)).empty?

          # parallelize with pmap (see config/initizlizers/celluloid.rb)
          batch.pmap do |input_file|

            record_files = self.write_mars_record_files(input_file)

            record_files.each do |record_file|
              
              # Run the translation to pbcore
              pbcore_collection_xml = Openvault::MARS.to_pbcore(mars_table, record_file)

              pbcore_description_documents = Openvault::Ingester::Pbcore.description_documents_from_xml(pbcore_collection_xml)

              pbcore_description_documents.each do |pbcore_ng_xml|
                ov_asset = OpenvaultAsset.new

                # set the pbcore datastream, the source xml datastream, and the depositor metadata
                ov_asset.pbcore.ng_xml = pbcore_ng_xml
                ov_asset.source_xml.content = File.read(record_file)
                ov_asset.apply_depositor_metadata args[:depositor]
                ov_asset.save!

                # Update the return value based self.ingest_return
                return_val = case self.ingest_return
                  when :count
                    return_val + 1
                  when :objects
                    return_val += [ov_asset]
                  when :pids
                    return_val += [ov_asset.pid]
                end
              end
            end

            self.delete_tmp_files(record_files) unless args[:keep_mars_record_files]
          end
        end

        # Return the ingested OpenvaultAsset models
        return_val
      end

      # .write_mars_record_files
      # Creates a new (temporary) XML document for each MARS record in `input_file`
      # Returns an array of the new filenames.
      def self.write_mars_record_files(input_file)
        # Parse the input file with Nokogiri
        xml_doc = Openvault::XML(File.read(input_file))

        # Grab the namespaces, then remove them. We do this because we want
        # to preserve the namespace declaration in the temp file, but we don't
        # want it around when we are parsing the document because Nokogiri has
        # this strange behavior where it will automatically inject a namespace
        # of "default:" to all child nodes. I think it is an outstanding bug.
        namespaces = xml_doc.namespaces

        xml_doc.remove_namespaces!

        # Get all of the mars records (i.e. <ROW>...</ROW>)
        xml_nodeset = xml_doc.xpath("//ROW")

        # Array to collect temp filenames
        mars_record_filenames = []

        # For each mars records, write a tmp file that is a complete xml document,
        # with the same root node and namespace as the originating document.
        # This is necessary for Openvault::MARS.to_pbcore to succesfully parse with XSLT.
        xml_nodeset.each do |xml_node|

          # Create a new xml document from root node of originating document.
          new_xml_doc = Openvault::XML("<#{xml_doc.root.name} />")

          # If the namespace is default (i.e. no prefix) then set it to nil
          # A value of `nil` for first to .add_namespace_definition will declare
          # a default namespace, i.e. xmlns="some-location"
          namespaces.each do |ns_prefix, ns_location|
            ns_prefix = nil if ns_prefix == 'xmlns'
            new_xml_doc.root.add_namespace_definition(ns_prefix, ns_location)
          end
          

          # Add the xml node to the new xml document.
          new_xml_doc.root.add_child xml_node

          tmp_filename = self.next_tmp_filename
          File.write(self.next_tmp_filename, new_xml_doc.to_xml)
          mars_record_filenames << tmp_filename
        end

        # return the list of temp mars record filenames, each now containing a single mars record,
        # complete with root node and namespace, and parsable by Openvault::MARS.to_pbcore.
        mars_record_filenames
      end

      def self.next_tmp_filename
        i, tmp_filename = 0, nil
        while (tmp_filename.nil? || File.exists?(tmp_filename))
          i += 1
          tmp_filename = "#{self.tmp_dir}/tmp_#{i.to_s}"
        end
        tmp_filename
      end

      # Returns all filenames from tmp_dir that match the file or glob.
      def self.tmp_filenames(files_or_globs='*')
        tmp_filenames = []
        files_or_globs = Array.wrap(files_or_globs)
        files_or_globs.each do |file_or_glob|
          # this wonky line removes the tmp_dir from beginnig of file_or_glob if it's there,
          # only to add it again, just to ensure it is there exactly once.
          file_or_glob = self.tmp_dir + "/" + file_or_glob.gsub(/^#{self.tmp_dir}\//, '')

          # Append all files that match the file or glob in the tmp directory.
          tmp_filenames += Dir[file_or_glob]
        end
        # and return all the filenames.
        tmp_filenames
      end

      def self.delete_tmp_files(files_or_globs)
        self.tmp_filenames(files_or_globs).each do |tmp_filename|
          File.delete(tmp_filename)
        end
      end

    end
  end
end