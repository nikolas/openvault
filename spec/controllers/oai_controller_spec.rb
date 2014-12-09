require 'spec_helper'
#require 'openvault/pbcore'

def oai_verb_works(verb)
  it "verb=#{verb}" do
    get :index, verb: verb
    expect(response.body).to match /<request [^>]*verb="#{verb}"[^>]*>/
    expect(response.body).to match /<#{verb}>/
    yield if block_given?
  end
end

describe OaiController do
  
  oai_verb_works('Identify')
  oai_verb_works('ListMetadataFormats')
  oai_verb_works('ListSets')
  
  it 'verb=GetRecord' do
    get :index, verb: 'GetRecord', identifier: '123', metadataPrefix: 'pbcore'
    expect(response.body).to match /<request [^>]*verb="GetRecord"[^>]*>/
    expect(response.body).to match /<GetRecord>/
  end
  
#  it 'verb=ListRecords' do
#    get :index, verb: 'ListRecords'
#    expect(response.body).to match /<request verb="ListRecords">/
#    expect(response.body).to match /<ListSets><\/ListSets>/
#  end

end