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
    visit "/custom_collections/#{values[:id]}/edit"
    fill_in 'custom_collection_name', with: values[:name] unless values[:name].nil?
    fill_in 'custom_collection_summary', with: values[:summary] unless values[:summary].nil?
  end
  
  def user_attach_file(values={})
    values.symbolize_keys!
    visit "/custom_collections/#{values[:id]}/edit"
    attach_file "#{values[:button_name]}", "./spec/factories/files/#{values[:file_name]}"
    click_button 'Update Custom collection'
  end
  
end

