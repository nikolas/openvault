FactoryGirl.define do

  # A factory for instances of Affiliation model.
  factory :affiliation do
    org { create(:org) }
    user { create(:user) }

    title { Faker::Name.title }

    primary false
  end
end
