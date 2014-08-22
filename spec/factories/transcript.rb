FactoryGirl.define do
  
  # A factory for instances of Series model.
  factory :transcript do

    ignore do
      # This will be available in in `evaluator.pbcore` in after(:build) hook below.
      pbcore do
        pbcore_desc_doc = PbcoreDescDoc.new
        pbcore_desc_doc.asset_type = 'blah blah TRANSCRIPT blah blah'
        pbcore_desc_doc
      end
    end

    after(:build) do |transcript, evaluator|
      transcript.pbcore.ng_xml = evaluator.pbcore.ng_xml
    end

  end
end