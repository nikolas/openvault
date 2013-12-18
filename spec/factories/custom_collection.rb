FactoryGirl.define do

  # A factory for instances of Custom Collections model.
  factory :custom_collection do

    name { Faker::Name.title }
    summary { Faker::Lorem.paragraph }

    # make the default owned by a User who is a 'scholar'
    association :owner, factory: :user, role: 'scholar'
  end
end