module AdminCustomCollectionSteps

  # Fills out the form for a CustomCollection with data from a newly created sample.
  def admin_fill_in_custom_collection_form
    sample = build(:custom_collection, owner: [User, Org].sample.random)
    fill_in 'custom_collection_name', with: sample.name
    fill_in 'custom_collection_summary', with: sample.summary
    select User.scholars.sample.last_name_first, from: 'custom_collection_owner_type_and_id'
  end

  # Fills out form for creating a new CustomCollection and submits it.
  def admin_create_custom_collection
    visit new_admin_custom_collection_path
    admin_fill_in_custom_collection_form
    click_on('Create Custom collection')
  end

  # Fills out the form for editing an existing CustomCollection and submits it.
  def admin_edit_custom_collection(id)
    visit edit_admin_custom_collection_path id
    admin_fill_in_custom_collection_form
    click_on('Update Custom collection')
  end
end