# encoding: UTF-8
require "spec_helper"

describe "routing for Audio" do

  it 'routes audio_path to audios#show' do
    expect(get: audio_path('123')).to route_to controller: 'audios', action: 'show', id: '123'
  end

end