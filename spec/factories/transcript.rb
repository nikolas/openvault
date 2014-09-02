FactoryGirl.define do
  
  factory :transcript do

    ignore do
      # This will be available in in `evaluator.pbcore` in after(:build) hook below.
      pbcore do
        pbcore_desc_doc = PbcoreDescDoc.new
        pbcore_desc_doc.asset_type = 'blah blah TRANSCRIPT blah blah'
        pbcore_desc_doc
      end
    end
    
    # TODO: bad copy-and-paste: https://github.com/afred/openvault/issues/670

    after(:build) do |transcript, evaluator|
      transcript.pbcore.ng_xml = evaluator.pbcore.ng_xml
    end

  end
end