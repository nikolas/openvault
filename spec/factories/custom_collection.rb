# require 'factory_girl'
# require 'faker'
# require_relative 'user'
# require_relative 'org'
# require_relative 'custom_collection_item'


FactoryGirl.define do

  # A factory for instances of Custom Collections model.
  factory :custom_collection do

    name { Faker::Company.catch_phrase }
    summary { Faker::Lorem.paragraph }

    # make the default owned by a User who is a 'scholar'
    association :owner, factory: :scholar_user


    trait :with_items do
      ignore do
        num_items 2
      end

      after(:create) do |custom_collection, evaluator|
        create_list(:custom_collection_item, evaluator.num_items, custom_collection: custom_collection)
      end
    end

    trait :with_collabs do
      ignore do
        num_collabs 2
      end

      after :create do |custom_collection, evaluator|
        create_list(:user, evaluator.num_collabs).each do |user|
          custom_collection.collabs << user
        end
      end
    end
  end
end
