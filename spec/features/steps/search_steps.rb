module SearchSteps
  def search(values={})
    values.symbolize_keys!
    go_here "/catalog?q=#{Rack::Utils.escape(values[:q])}"
  end
  
  def filter_click(values={})
    values.symbolize_keys!
    click_on values[:filter]
  end
  
  def sort_click(values={})
    values.symbolize_keys!
    select values[:sort], from: 'sort' unless values[:sort].nil?
  end
  
end
