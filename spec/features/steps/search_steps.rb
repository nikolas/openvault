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
  
  def insert_search_result
    #logic to insert atleast 10 results
    ActiveFedora::Base.all.each do |ab|
      ab.delete
    end
    Fixtures.cwd("#{fixture_path}/pbcore")
    (1..3).each do |n|
      a = Openvault::Pbcore::DescriptionDocumentWrapper.new(Fixtures.use("artesia/rock_and_roll/video_#{n}.xml")).model
      a.save!
      a.create_relations_from_pbcore!
    end
  end
  
end