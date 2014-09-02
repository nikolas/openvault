FactoryGirl.define do
  
  factory :audio do
    skip_create

    ignore do
      # This will be available in in `evaluator.pbcore` in after(:build) hook below.
      pbcore do
        pbcore_desc_doc = PbcoreDescDoc.new
        # Is this ok? Or is it too fixture-ish?
        pbcore_desc_doc.ng_xml = Openvault::XML('<pbcoreDescriptionDocument><pbcoreInstantiation><instantiationMediaType>audio</instantiationMediaType></pbcoreInstantiation></pbcoreDescriptionDocument>')
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