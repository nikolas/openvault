module Openvault
  module MARS
    class << self

      # MARS_TABLES are the Filemaker Pro tables in the MARS database.
      # Stylesheets for converting to pbcore are specific to each table.
      MARS_TABLES = [:assets, :programs, :mats_used, :logs]

      @@stylesheets = {
        :assets => File.expand_path('../mars/mars_to_pbcore2.assets.xsl', __FILE__)
      }

      def to_pbcore(mars_table, input_filename)
        cmd = self.build_xsltproc_command(self.stylesheet_for(mars_table), input_filename)
        %x(#{cmd})
      end

      def build_xsltproc_command(xsl_stylesheet, input_filename, output_filename=nil)
        cmd = 'xsltproc'
        cmd += " -o #{output_filename}" unless output_filename.nil?
        cmd += " #{xsl_stylesheet}"
        cmd += " #{input_filename}"
        cmd
      end

      def stylesheet_for(mars_table)
        @@stylesheets[self.mars_table(mars_table)]
      end

      def mars_table(mars_table)
        raise "Invalid MARS table. Available types are #{MARS_TABLES.join(',')}." unless MARS_TABLES.include? mars_table.to_sym
        mars_table.to_sym
      end

    end
  end
end