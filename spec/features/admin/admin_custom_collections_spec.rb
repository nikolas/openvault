require 'spec_helper'
require 'features/admin/spec_helper'

Capybara.asset_host = 'http://localhost:3000'

feature 'CRUD for Custom Collections:' do

  context 'As an Admin' do

    before(:context) {
      # create some scholars and some organizations who can act as owners of custom collections
      create_list(:scholar_user, 3)
      create_list(:org, 3)

      @admin = create(:user, admin: true)
    }

    before(:example) do
      # Logging in before(:context) doesn't seem to work for all examples, so
      # we login for each example
      login_as(@admin)
    end


    scenario 'I can create custom collections using the admin interface' do
      admin_create_custom_collection
      expect(page).to have_content 'Custom collection was successfully created'
    end

    context 'when editing a custom collection' do

      let(:custom_collection) { create(:custom_collection) }

      scenario 'the "Owner" field is populated correctly', :admin do
        visit edit_admin_custom_collection_path custom_collection.id
        expect(page).to have_select('custom_collection_owner_type_and_id', selected: owner_option_text(custom_collection.owner_type_and_id))
      end

      scenario 'I can save new values to the custom collection' do
        admin_edit_custom_collection custom_collection.id
        expect(page).to have_content 'Custom collection was successfully updated.'
      end
    end

  end
end
