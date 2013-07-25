module CustomCollectionSteps
  
  def create_custom_collection(values={})
    values.symbolize_keys!
    retry_on_timeout do
      visit new_custom_collection_path
      fill_in 'custom_collection_name', with: values[:name] unless values[:name].nil?
      fill_in 'custom_collection_summary', with: values[:summary] unless values[:summary].nil?
      #page.execute_script("var wysihtml5Editor = $('#custom_collection_summary').data('wysihtml5').editor; wysihtml5Editor.composer.commands.exec('insertHTML', '#{values[:summary]}');")
      click_button 'Create Custom collection'
    end
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
  
  def retry_on_timeout(n = 3, &block)
    block.call
  rescue Capybara::ElementNotFound => e
    if n > 0
      puts "Catched error: #{e.message}. #{n-1} more attempts."
      retry_on_timeout(n - 1, &block)
    else
      raise
    end
  end
  
end

