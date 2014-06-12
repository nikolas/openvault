FactoryGirl.define do

  # A factory for instances of Custom Collections model.
  factory :custom_collection do

    name { Faker::Name.title }
    summary { Faker::Lorem.paragraph }

    # make the default owned by a User who is a 'scholar'
    association :owner, factory: :scholar_user
  end

  factory :custom_collection_with_items, parent: :custom_collection do
    after(:create) do |cc|
      cc.save! # TODO: Why is this necessary?
      5.times do
        cc.custom_collection_items << FactoryGirl.create(:custom_collection_item)
      end
    end
  end
end
