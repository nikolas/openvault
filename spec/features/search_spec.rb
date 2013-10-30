require 'spec_helper'
require 'helpers/test_helper'
require 'openvault'
require 'openvault/pbcore'
require "#{RSpec.configuration.fixture_path}/pbcore/load_fixtures"
include Warden::Test::Helpers
Warden.test_mode!

feature 'User searches' do
  before :all do
    insert_search_result
  end
  describe "user search features" do
    scenario 'and there are no results' do
      search({q: 'asdfasdfasdfasdfasdfasdf'})
      expect(page).to have_content('We did not find any matches for this search')
    end
  
    scenario 'and there are less than 10 results' do
      search({q: 'Interview with Rufus Thomas'})
      expect(page).to have_css("#documents .document", :count => 1)
    end
  
    scenario 'and there are more than 10 results' # do
 #      search({q: ''})
 #      expect(page).to have_css('.pager')
 #    end
    
    #need to fix facets display for this to work
    # scenario 'and they filter with a facet' do
#       search({q: 'Nova'})
#       save_and_open_page
#       filter_click({filter: 'Robin Bates'})
#       expect(page).to have_css('#appliedParams .filterValue a', text: 'Robin Bates')
#     end
  
    scenario 'and they sort by title' # do
 #      search({q: 'Rock and Roll'})
 #      sort_click({sort: 'title'})
 #      #need something more robust than this
 #      expect(page).to have_css('#documents .document')
 #    end
  
    scenario 'and they sort by date' # do
 #      search({q: 'Rock and Roll'})
 #      sort_click({sort: 'year'})
 #      #need something more robust than this
 #      expect(page).to have_css('#documents .document')
 #    end
  end
end