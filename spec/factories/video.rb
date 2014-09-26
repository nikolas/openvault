FactoryGirl.define do
  
  factory :video do
    skip_create

    ignore do
      # This will be available in in `evaluator.pbcore` in after(:build) hook below.
      pbcore do
        pbcore_desc_doc = PbcoreDescDoc.new
        pbcore_desc_doc.asset_type = 'preservation MASTER'
        pbcore_desc_doc
      end
    end

    # TODO: bad copy-and-paste: https://github.com/afred/openvault/issues/670
    
    after(:build) do |video, evaluator|
      video.pbcore.ng_xml = evaluator.pbcore.ng_xml
    end

    after(:create) do |video, evaluator|
      # This is necessary because of `skip_create` above. We are not creating things the way FG does by default,
      # so we do it manually.
      video.save!
    end
  end
  
end