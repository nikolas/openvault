module CustomCollectionSteps
  
  def create_custom_collection(values={})
    values.symbolize_keys!
    visit new_custom_collection_path
    fill_in 'custom_collection_name', with: values[:name] unless values[:name].nil?
    fill_in 'custom_collection_summary', with: values[:summary] unless values[:summary].nil?
    click_button 'Create Custom collection'
  end
  
  def edit_custom_collection(values={})
    values.symbolize_keys!
    visit "/custom_collection/#{values[:id]}/edit"
    fill_in 'custom_collection_name', with: values[:name] unless values[:name].nil?
    fill_in 'custom_collection_summary', with: values[:summary] unless values[:summary].nil?
  end
  
end