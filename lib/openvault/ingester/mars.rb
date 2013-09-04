require 'openvault/mars'
require 'openvault/ingester/pbcore'

module Openvault
  class Ingester
    class MARS

      @@tmp_dir = File.expand_path('../mars/tmp/', __FILE__)

      @@mars_record_filename_prefix = "mars_record_"

      cattr_accessor :tmp_dir, :mars_record_filename_prefix

      # overwrite class attr writer for @@tmp_dir to verify it's a writable directory
      def self.tmp_dir=(dirname)
        raise "Cannot set tmp_dir to #{dirname}, it's not a directory" unless File.directory? dirname
        @@tmp_dir = dirname
      end

      def self.ingest!(mars_table, args)

        raise 'No input files specified. Specify MARS input filenames :files option.' if (args[:files].nil? && args[:xml].nil?)

        input_files = Array.wrap(args[:files]) unless args[:files].nil?

        # Return if nothing to do.
        return if input_files.empty?

        ov_assets = []

        # debugger

        input_files.each do |input_file|

          # Isolate all MARS records from input_files into individual files, one file per MARS record.
          record_files = self.write_mars_record_files(input_file)

          # debugger

          record_files.each do |record_file|
            
            # Run the xslt translation to pbcore
            pbcore_collection_xml = Openvault::MARS.to_pbcore(mars_table, record_file)

            pbcore_description_documents = Openvault::Ingester::Pbcore.description_documents_from_xml(pbcore_collection_xml)

            pbcore_description_documents.each do |pbcore_ng_xml|
              ov_asset = OpenvaultAsset.new

              # set the pbcore datastream, the source xml datastream, and the depositor metadata
              ov_asset.pbcore.ng_xml = pbcore_ng_xml
              ov_asset.source_xml.content = File.read(record_file)
              ov_asset.apply_depositor_metadata args[:depositor]

              # save the OpenvaultAsset model, and append to return array
              ov_asset.save!
              ov_assets << ov_asset
            end
          end

          self.delete_mars_record_files unless args[:keep_mars_record_files]
        end

        # Return the ingested OpenvaultAsset models
        ov_assets
      end

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
          # ns_prefix = nil if ns_prefix == 'xmlns'
          namespaces.each do |ns_prefix, ns_location|
            ns_prefix = nil if ns_prefix == 'xmlns'
            new_xml_doc.root.add_namespace_definition(ns_prefix, ns_location)
          end
          

          # Add the xml node to the new xml document.
          new_xml_doc.root.add_child xml_node

          # Write the xml output to a new temp mars record file,
          # and append the new temp filename to the return array.
          mars_record_filename = self.next_mars_record_filename
          File.write(mars_record_filename, new_xml_doc.to_xml)
          mars_record_filenames << mars_record_filename
        end

        # return the list of temp mars record filenames, each now containing a single mars record,
        # complete with root node and namespace, and parsable by Openvault::MARS.to_pbcore.
        mars_record_filenames
      end

      # Combines temp dir, file prefix, and a number to make a temp filename for storing mars records.
      def self.mars_record_filename(num)
        "#{@@tmp_dir}/#{@@mars_record_filename_prefix}_#{num.to_s}"
      end

      # Returns the next temp filename for writing a mars record
      def self.next_mars_record_filename
        i = 1
        while File.exists? self.mars_record_filename(i)
          i+=1
        end
        self.mars_record_filename(i)
      end

      def self.delete_mars_record_files
        Dir["#{@@tmp_dir}/#{@@mars_record_filename_prefix}_*"].each {|tmp_file| File.delete(tmp_file)}
      end

    end
  end
end