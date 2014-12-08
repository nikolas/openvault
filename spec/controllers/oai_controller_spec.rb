require 'spec_helper'
#require 'openvault/pbcore'

describe OaiController do

  it 'verb=Identify' do
    get :index, verb: 'Identify'
    expect(response.body).to match /<request verb="Identify">/
  end

  it 'verb=ListMetadataFormats' do
    get :index, verb: 'ListMetadataFormats'
    expect(response.body).to match /<request verb="ListMetadataFormats">/
    expect(response.body).to match /<metadataPrefix>pbcore<\/metadataPrefix>/
  end
  
  it 'verb=ListSets' do
    get :index, verb: 'ListSets'
    expect(response.body).to match /<request verb="ListSets">/
    expect(response.body).to match /<ListSets><\/ListSets>/
  end
  
end