FactoryGirl.define do
  
  # A factory for instances of Series model.
  factory :series do

    skip_create

    ignore do
      # This will be available in in `evaluator.pbcore` in after(:build) hook below.
      pbcore do
        pbcore_desc_doc = PbcoreDescDoc.new
        pbcore_desc_doc.series_title += [Faker::Lorem.words(rand(1..5)).join(' ')]
        pbcore_desc_doc
      end
    end

    after(:build) do |new_series, evaluator|
      new_series.pbcore.ng_xml = evaluator.pbcore.ng_xml
    end

    # after(:create) do |new_series, evaluator|
    #   new_series.save!
    #   # new_series.programs += create_list(:program, evaluator.programs_count, series: new_series) unless evaluator.programs_count.nil?
    # end
  
  end
end