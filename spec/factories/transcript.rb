FactoryGirl.define do
  
  # A factory for instances of Series model.
  factory :transcript do

    ignore do
      # This will be available in in `evaluator.pbcore` in after(:build) hook below.
      pbcore do
        pbcore_desc_doc = PbcoreDescDoc.new
      end
    end

    after(:build) do |new_series, evaluator|
      new_series.pbcore.ng_xml = evaluator.pbcore.ng_xml
    end

  end
end