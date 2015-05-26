require 'spec_helper'
require "#{RSpec.configuration.fixture_path}/pbcore/load_fixtures"
require 'openvault/pbcore'
require 'openvault/slug_setter'

require 'date'

describe OaiController do
  
  ROWS = 100
  
  def load_save(asset, path)
    asset.pbcore.ng_xml = Fixtures.raw(path)
    asset.save!
  end
  
  before(:all) do 
    Fixtures.cwd("#{fixture_path}/pbcore")
        
    # We'll expect to find this image
    Image.new.tap { |image|
      load_save(image, 'artesia/march_on_washington/image_1.xml')
      Openvault::SlugSetter.reset_slug(id: image.id, slug: 'SLUG')
    }

    # ... but not this one, after we relate it to a video.
    image_to_relate = Image.new.tap { |image|
      load_save(image, 'artesia/rock_and_roll/image_1.xml')
      Openvault::SlugSetter.reset_slug(id: image.id, slug: 'RELATED')
    }
    
    # The video itself will be returned.
    video = Video.new.tap { |video| load_save(video, "artesia/rock_and_roll/video_1.xml")}
    Openvault::Pbcore::AssetRelationshipBuilder.new(image_to_relate).relate(video)
    image_to_relate.save! # So that has_related_video is set properly
    
    # TODO: For reasons I don't understand, the slug is lost after being related,
    # so we re-establish it here. issue #1096
    Openvault::SlugSetter.reset_slug(id: image_to_relate.id, slug: 'RELATED')
    
    # Program won't be returned.
    Program.new.tap { |program| load_save(program, "artesia/rock_and_roll/program_1.xml") }
    
    # Filler so we can test resumptionTokens
    ROWS.times do
      Audio.new.tap { |audio| load_save(audio, "artesia/patriots_day/audio_3.xml") }
    end
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
      test.expect(xml).to test.match "<earliestDatestamp>#{Time.now.utc.to_date}" # just ingested.
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
      test.expect(xml).not_to test.match '<identifier>http://openvault.wgbh.org/catalog/RELATED</identifier>'
      test.expect(xml.scan('<identifier>').count).to test.eq(ROWS)
      test.expect(xml).to test.match "<resumptionToken>#{ROWS}</resumptionToken>"
    end
    expect_oai('ListIdentifiers', resumptionToken: ROWS) do |test, xml|
      test.expect(xml).not_to test.match '<identifier>http://openvault.wgbh.org/catalog/RELATED</identifier>'
      test.expect(xml.scan('<identifier>').count).to test.eq(2)
      test.expect(xml).not_to test.match '<resumptionToken>'
    end
  end
  
  it 'ListRecords' do
    expect_oai('ListRecords', metadataPrefix: 'pbcore') do |test, xml|
      # Assumes order of response equals order of ingest, otherwise might not be in first chunk.
      test.expect(xml).to test.match '<identifier>http://openvault.wgbh.org/catalog/SLUG</identifier>'
      test.expect(xml).not_to test.match '<identifier>http://openvault.wgbh.org/catalog/RELATED</identifier>'
      test.expect(xml).to test.match 'Civil rights march'
      test.expect(xml.scan('<identifier>').count).to test.eq(ROWS)
      test.expect(xml).to test.match "<resumptionToken>#{ROWS}</resumptionToken>"
    end
    expect_oai('ListRecords', resumptionToken: ROWS) do |test, xml|
      test.expect(xml).not_to test.match '<identifier>http://openvault.wgbh.org/catalog/RELATED</identifier>'
      test.expect(xml.scan('<identifier>').count).to test.eq(2)
      test.expect(xml).not_to test.match '<resumptionToken>'
    end
  end
  
end