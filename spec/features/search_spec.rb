require 'spec_helper'
require 'helpers/test_helper'
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
      search({q: 'death of a star'})
      expect(page).to have_css("#documents .document", :count => 2)
    end
  
    scenario 'and there are more than 10 results' do
      search({q: 'Nova'})
      expect(page).to have_css('.pager')
    end
  
    scenario 'and they filter with a facet' do
      search({q: 'Nova'})
      filter_click({filter: 'Robin Bates'})
      expect(page).to have_css('#appliedParams .filterValue a', text: 'Robin Bates')
    end
  
    scenario 'and they sort by title' do
      search({q: 'Nova'})
      sort_click({sort: 'title'})
      #need something more robust than this
      expect(page).to have_css('#documents .document')
    end
  
    scenario 'and they sort by date' do
      search({q: 'Nova'})
      sort_click({sort: 'year'})
      #need something more robust than this
      expect(page).to have_css('#documents .document')
    end
  end
end