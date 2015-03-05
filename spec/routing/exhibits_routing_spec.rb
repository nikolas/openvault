require "spec_helper"

describe "routing for exhibits" do


  @legacy_urls_to_new_routes = {
    'catalog/44ffa1-rock-and-roll' => {controller: 'exhibits', action: 'rock_and_roll'},
    'catalog/roll-rock-and-roll' => {controller: 'exhibits', action: 'rock_and_roll'},
    'collections/roll-rock-and-roll' => {controller: 'exhibits', action: 'rock_and_roll'},
    'catalog/wpna-wpna-war-and-peace-in-the-nuclear-age'  => {controller: 'exhibits', action: 'wpna'},
    'collections/wpna-wpna-war-and-peace-in-the-nuclear-age'  => {controller: 'exhibits', action: 'wpna'},
    'catalog/vietnam-the-vietnam-collection'  => {controller: 'exhibits', action: 'vietnam'},
    'collections/vietnam-the-vietnam-collection'  => {controller: 'exhibits', action: 'vietnam'},
    'catalog/prpe-press-and-the-people'  => {controller: 'exhibits', action: 'press_and_people'},
    'collections/prpe-press-and-the-people'  => {controller: 'exhibits', action: 'press_and_people'},
    'catalog/press-and-people'  => {controller: 'exhibits', action: 'press_and_people'},
    'collections/press-and-people'  => {controller: 'exhibits', action: 'press_and_people'},
    'catalog/march-march-on-washington'  => {controller: 'exhibits', action: 'march_on_washington'},
    'collections/march-march-on-washington'  => {controller: 'exhibits', action: 'march_on_washington'},
    'catalog/sbro-say-brother'  => {controller: 'exhibits', action: 'say_brother'},
    'collections/sbro-say-brother'  => {controller: 'exhibits', action: 'say_brother'},
    'catalog/vault-from-the-vault'  => {controller: 'exhibits', action: 'from_the_vault'},
    'collections/vault-from-the-vault'  => {controller: 'exhibits', action: 'from_the_vault'},
    'catalog/advocates-advocates'  => {controller: 'exhibits', action: 'advocates'},
    'collections/advocates-advocates'  => {controller: 'exhibits', action: 'advocates'},
    'collections' => {controller: 'exhibits', action: 'index'}
  }

  # Normally I don't like creating test dynamically, especially within loops. But this is straightforward enough.
  # If it gets any more complicated than this, feel free to refactor it.
  @legacy_urls_to_new_routes.each do |legacy_url, new_route|
    it "routes #{legacy_url} to #{new_route}" do
      expect(get: legacy_url).to route_to(new_route)
    end
  end
  
end