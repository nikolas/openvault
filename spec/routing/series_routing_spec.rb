# encoding: UTF-8
require "spec_helper"

describe "routing for Series" do

  it 'routes "/series/:id/print" to series#print' do
    {get: '/series/1234567890/print'}.should route_to controller: 'series', action: 'print', id: '1234567890'
  end

  it 'routes "/series" to series#browse_by_title' do
    {get: '/series'}.should route_to controller: 'series', action: 'browse_by_title'
  end

end