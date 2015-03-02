require "spec_helper"

describe "routing for overrides" do

  it 'routes catalog' do
    expect(get: 'catalog/advocates-advocates').to route_to(
      controller: 'catalog', action: 'show', id: 'advocates-advocates')
  end
  
  it 'routes roll_rock_and_roll' do
    expect(get: 'catalog/44ffa1-rock-and-roll').to route_to(
      controller: 'override', action: 'show_rock_and_roll')
  end
  
end