# encoding: UTF-8
require "spec_helper"

describe "routing for Series" do

  it 'routes browse_series_path to series#browse_by_title' do
    expect(get: browse_series_path).to route_to controller: 'series', action: 'browse_by_title'
  end

end