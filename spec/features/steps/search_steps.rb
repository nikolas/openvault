module SearchSteps
  
  def search(values={})
    values.symbolize_keys!
    retry_on_timeout do
      go_here '/'
      fill_in 'q', with: values[:q] unless values[:q].nil?
      click_button 'search'
    end
  end
  
  def filter_click(values={})
    values.symbolize_keys!
    retry_on_timeout do
      click_on values[:filter]
    end
  end
  
  def sort_click(values={})
    values.symbolize_keys!
    retry_on_timeout do
      select values[:sort], from: 'sort' unless values[:sort].nil?
    end
  end
  
  def insert_search_result
    #logic to insert atleast 10 results
    ActiveFedora::Base.all.each do |ab|
      ab.delete
    end
    ng = Openvault::XML(open("#{fixture_path}/pbcore/mars/programs_1.xml"))
    all_docs = ng.xpath("//x:pbcoreDescriptionDocument", "x" => "http://www.pbcore.org/PBCore/PBCoreNamespace.html")
  	all_docs.each do |doc|
  		ov = OpenvaultAsset.new
  		ov.apply_depositor_metadata '1123@me.com'
  		ov.pbcore.ng_xml = doc
  		ov.save
  	end
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