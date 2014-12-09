require 'spec_helper'
require "#{RSpec.configuration.fixture_path}/pbcore/load_fixtures"
#require 'openvault/pbcore'

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
    @audio = Audio.new
    @audio.pbcore.ng_xml = Fixtures.raw("artesia/patriots_day/audio_3.xml")
    @audio.save!
  end
  
  oai_verb_works('Identify')
  oai_verb_works('ListMetadataFormats')
  oai_verb_works('ListSets')
  oai_verb_works('GetRecord', identifier: '123', metadataPrefix: 'pbcore')
  oai_verb_works('ListIdentifiers', metadataPrefix: 'pbcore')
  oai_verb_works('ListRecords', metadataPrefix: 'pbcore') { |test, xml|
    test.expect(xml).to test.match /<record><header><identifier>/
  }

end