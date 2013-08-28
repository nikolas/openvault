require 'spec_helper'
require 'openvault/mars'
require "#{RSpec.configuration.fixture_path}/mars/load_fixtures"

describe Openvault::MARS do

  describe '.build_xsltproc_command' do
    it 'returns the command to run "xsltproc" with option for output file when specified' do
      Openvault::MARS.build_xsltproc_command('path/to/stylesheet.xsl', 'path/to/input.xml', 'path/to/output.xml').should == 'xsltproc -o path/to/output.xml path/to/stylesheet.xsl path/to/input.xml'
    end

    it 'returns the command to run "xsltproc" without option for output file when not specified' do
      Openvault::MARS.build_xsltproc_command('path/to/stylesheet.xsl', 'path/to/input.xml').should == 'xsltproc path/to/stylesheet.xsl path/to/input.xml'
    end
  end


  describe '.stylesheet_for' do
    it 'returns the path to the xsl stylesheet for converting MARS "assets" to pbcore' do
      File.exists?(Openvault::MARS.stylesheet_for(:assets)).should == true
    end

    pending 'returns the path to the xsl stylesheet for converting MARS "materials used" to pbcore' do
      File.exists?(Openvault::MARS.stylesheet_for(:mats_used)).should == true
    end

    pending 'returns the path to the xsl stylesheet for converting MARS "programs" to pbcore' do
      File.exists?(Openvault::MARS.stylesheet_for(:programs)).should == true
    end
  end


  describe '.mars_to_pbcore' do

    before(:all) { Fixtures.cwd("#{fixture_path}/mars") }

    it 'uses xsl stylesheet to convert MARS asset records to PBCore' do
      Openvault::MARS.to_pbcore(:assets, Fixtures.file_path('asset_1.xml')).should == Fixtures.raw('as_pbcore/asset_1.xml')
    end

  end
end