FactoryGirl.define do
  
  factory :program do
    
    skip_create
    
    ignore do
      pbcore do
          pbcore_desc_doc = PbcoreDescDoc.new
          pbcore_desc_doc.program_title += [Faker::Lorem.words(rand(1..5)).join(' ')]
          pbcore_desc_doc
      end
    end
    
    # TODO: bad copy-and-paste: https://github.com/afred/openvault/issues/670
    
    after(:build) do |new_series, evaluator|
      new_series.pbcore.ng_xml = evaluator.pbcore.ng_xml
    end

    after(:create) do |new_series, evaluator|
      # This is necessary because of `skip_create` above. We are not creating things the way FG does by default,
      # so we do it manually.
      new_series.save!
      # new_series.programs += create_list(:program, evaluator.programs_count, series: new_series) unless evaluator.programs_count.nil?
    end
    
  end
  
end