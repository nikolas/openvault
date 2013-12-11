FactoryGirl.define do

  # A factory for instances of Custom Collections model.
  factory :custom_collection do

    name { Faker::Name.title }
    summary { Faker::Lorem.paragraph }

    # make the default owned by a User who is a 'scholar'
    association :owner, factory: :user, role: 'scholar'

    # Additional factory for CustomCollection owned by an Org
    factory :custom_collection_owned_by_org do
      association :owner, factory: :org
    end
  end
end