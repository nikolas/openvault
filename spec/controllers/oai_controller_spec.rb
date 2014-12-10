require 'spec_helper'
require "#{RSpec.configuration.fixture_path}/pbcore/load_fixtures"
require 'openvault/pbcore'
require 'openvault/slug_setter'

require 'date'

def oai_verb_works(verb, *opts)
  it "verb=#{verb}" do
    args = Hash[*opts]
    args[:verb] = verb
    get :index, args
    expect(response.body).to match /<request [^>]*verb="#{verb}"[^>]*>/
    expect(response.body).to match /<#{verb}>/
    yield(self, response.body) if block_given?
  end
end

describe OaiController do
  
  before(:all) do 
    Fixtures.cwd("#{fixture_path}/pbcore")
    
    image = Image.new
    image.pbcore.ng_xml = Fixtures.raw("artesia/march_on_washington/image_1.xml")
    image.save!
    
    Openvault::SlugSetter.reset_slug(id: image.id, slug: 'SLUG')
    
    10.times do
      audio = Audio.new
      audio.pbcore.ng_xml = Fixtures.raw("artesia/patriots_day/audio_3.xml")
      audio.save!
    end
    
    series = Series.new
    series.pbcore.ng_xml = Fixtures.raw("artesia/rock_and_roll/program_1.xml")
    series.save!
  end
  
  oai_verb_works('Identify') do |test, xml|
    test.expect(xml).to test.match "<earliestDatestamp>#{Date.today}" # just ingested.
  end
  
  oai_verb_works('ListMetadataFormats') do |test, xml|
    test.expect(xml).to test.match '<metadataPrefix>oai_dc</metadataPrefix>'
    test.expect(xml).to test.match '<metadataPrefix>pbcore</metadataPrefix>'
  end
  
  oai_verb_works('ListSets') do |test, xml|
    test.expect(xml).to test.match '<ListSets></ListSets>'
  end
  
  oai_verb_works('GetRecord', identifier: 'SLUG', metadataPrefix: 'pbcore') do |test, xml|
    test.expect(xml).to test.match '<identifier>http://openvault.wgbh.org/catalog/SLUG</identifier>'
    test.expect(xml).to test.match 'Civil rights march'
  end
  
  oai_verb_works('ListIdentifiers', metadataPrefix: 'pbcore') do |test, xml|
    # Assumes order of response equals order of ingest, otherwise might not be in first chunk.
    test.expect(xml).to test.match '<identifier>http://openvault.wgbh.org/catalog/SLUG</identifier>'
    
    test.expect(xml.scan('<identifier>').count).to test.eq(10)
  end
  
  oai_verb_works('ListRecords', metadataPrefix: 'pbcore') do |test, xml|
    # Assumes order of response equals order of ingest, otherwise might not be in first chunk.
    test.expect(xml).to test.match '<identifier>http://openvault.wgbh.org/catalog/SLUG</identifier>'
    test.expect(xml).to test.match 'Civil rights march'
  
    test.expect(xml.scan('<identifier>').count).to test.eq(10)
  end

end