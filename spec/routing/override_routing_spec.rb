require "spec_helper"

describe "routing for Static" do

  it 'routes collections' do
    expect(get: 'collections/advocates-advocates').to route_to controller: 'static', action: 'show', file: 'advocates-advocates'
  end

  it 'blocks weird non-collections' do
    expect(get: 'collections/.../weird/...').not_to be_routable
  end

# TODO: Documentation suggests 'redirect_to' should exist, but it doesn't work for me.
#  it 'redirects series collections' do
#    expect(get: 'catalog/advocates-advocates').to redirect_to '???'
#  end
  
end