require "spec_helper"

describe "routing for overrides" do

  it 'routes collections' do
    expect(get: 'collections/advocates-advocates').to route_to(
      controller: 'override', action: 'show', path: 'collections/advocates-advocates')
    # TODO: Hmm: why doesn't the 'collections' route grab this? Does this not capture redirects?
  end

  it 'routes catalog' do
    expect(get: 'catalog/advocates-advocates').to route_to(
      controller: 'catalog', action: 'show', id: 'advocates-advocates')
  end
  
  it 'routes roll_rock_and_roll' do
    expect(get: 'catalog/roll-rock-and-roll').to route_to(
      controller: 'override', action: 'show_rock_and_roll')
  end
  
end