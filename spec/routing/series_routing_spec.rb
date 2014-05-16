# encoding: UTF-8
require "spec_helper"

describe "routing for Series" do

  it 'routes print_series_path to series#print' do
    expect(get: print_series_path('123')).to route_to controller: 'series', action: 'print', id: '123'
  end

  it 'routes series_path to series#show' do
    expect(get: series_path('123')).to route_to controller: 'series', action: 'show', id: '123'
  end

  it 'routes browse_series_path to series#browse_by_title' do
    expect(get: browse_series_path).to route_to controller: 'series', action: 'browse_by_title'
  end

end