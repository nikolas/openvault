require 'spec_helper'
require "#{RSpec.configuration.fixture_path}/pbcore/load_fixtures"
require 'openvault/pbcore'
require 'openvault/slug_setter'

require 'date'

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
  
  def expect_oai(verb, *opts)
    args = Hash[*opts]
    args[:verb] = verb
    get :index, args
    expect(response.body).to match /<request [^>]*verb="#{verb}"[^>]*>/
    expect(response.body).to match /<#{verb}>/
    yield(self, response.body) if block_given?
  end
  
  it 'Identify' do
    expect_oai('Identify') do |test, xml|
      test.expect(xml).to test.match "<earliestDatestamp>#{Date.today}" # just ingested.
    end
  end
  
  it 'ListMetadataFormats' do
    expect_oai('ListMetadataFormats') do |test, xml|
      test.expect(xml).to test.match '<metadataPrefix>oai_dc</metadataPrefix>'
      test.expect(xml).to test.match '<metadataPrefix>pbcore</metadataPrefix>'
    end
  end
  
  it 'ListSets' do
    expect_oai('ListSets') do |test, xml|
      test.expect(xml).to test.match '<ListSets></ListSets>'
    end
  end
  
  it 'GetRecord' do
    expect_oai('GetRecord', identifier: 'SLUG', metadataPrefix: 'pbcore') do |test, xml|
      test.expect(xml).to test.match '<identifier>http://openvault.wgbh.org/catalog/SLUG</identifier>'
      test.expect(xml).to test.match 'Civil rights march'
    end
  end
  
  it 'ListIdentifiers' do
    expect_oai('ListIdentifiers', metadataPrefix: 'pbcore') do |test, xml|
      # Assumes order of response equals order of ingest, otherwise might not be in first chunk.
      test.expect(xml).to test.match '<identifier>http://openvault.wgbh.org/catalog/SLUG</identifier>'
      test.expect(xml.scan('<identifier>').count).to test.eq(10)
      test.expect(xml).to test.match '<resumptionToken>10</resumptionToken>'
    end
    expect_oai('ListIdentifiers', resumptionToken: '10') do |test, xml|
      test.expect(xml.scan('<identifier>').count).to test.eq(1)
      test.expect(xml).not_to test.match '<resumptionToken>'
    end
  end
  
  it 'ListRecords' do
    expect_oai('ListRecords', metadataPrefix: 'pbcore') do |test, xml|
      # Assumes order of response equals order of ingest, otherwise might not be in first chunk.
      test.expect(xml).to test.match '<identifier>http://openvault.wgbh.org/catalog/SLUG</identifier>'
      test.expect(xml).to test.match 'Civil rights march'
      test.expect(xml.scan('<identifier>').count).to test.eq(10)
      test.expect(xml).to test.match '<resumptionToken>10</resumptionToken>'
    end
    expect_oai('ListRecords', resumptionToken: '10') do |test, xml|
      test.expect(xml.scan('<identifier>').count).to test.eq(1)
      test.expect(xml).not_to test.match '<resumptionToken>'
    end
  end
  
end