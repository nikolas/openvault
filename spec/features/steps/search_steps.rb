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
    Fixtures.cwd("#{fixture_path}/pbcore")
    (1..3).each do |n|
      a = Openvault::Pbcore.get_model_for(Fixtures.use("artesia/rock_and_roll/video_#{n}.xml"))
      a.save!
      a.create_relations_from_pbcore_artesia!
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