require 'spec_helper'
#require 'openvault/pbcore'

describe OaiController do

  it 'verb=Identify' do
    get :index, verb: 'Identify'
    expect(response.body).to match /<request verb="Identify">/
  end

end