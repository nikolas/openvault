FactoryGirl.define do

  # A factory for instances of Custom Collections model.
  factory :org do

    name { Faker::Name.title }
    desc { Faker::Lorem.paragraph }

  end
end