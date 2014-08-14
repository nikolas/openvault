require 'factory_girl'
require 'faker'
require 'artesia'
require 'mars'

FactoryGirl.define do

  factory :pbcore_desc_doc do

    skip_create

    trait :with_artesia_id do
      after(:build) do |pb, evaluator|
        pb.all_ids += [Artesia::ID.generate]
        pb.all_ids(pb.all_ids.count-1).source = 'UOI_ID'
      end
    end

    trait :with_mars_asset_id do
      after(:build) do |pb, evaluator|
        pb.all_ids += [MARS::ID.generate('A_')]
        pb.all_ids(pb.all_ids.count - 1).source = 'MARS Asset Record ID'
      end
    end

    trait :with_mars_program_id do
      after(:build) do |pb, evaluator|
        pb.all_ids += [MARS::ID.generate('P_')]
        pb.all_ids(pb.all_ids.count - 1).source = 'MARS Program Record ID'
      end
    end

    trait :with_series_title do
      series_title do
        t = [
          "#{Faker::Hacker.adjective} #{Faker::Hacker.noun}",
          "#{Faker::Hacker.ingverb} in #{Faker::Address.city}",
          "#{Faker::Hacker.ingverb} in #{Faker::Commerce.color}",
          "#{Faker::Hacker.ingverb} #{Faker::Hacker.noun.pluralize} with #{Faker::Name.name}",
          "#{Faker::Hacker.noun}",
          "#{Faker::Hacker.noun.pluralize}",
          ].sample

        t += " with #{Faker::Name.name}" if (rand(5) % 5) == 0

        t.titleize
      end
    end

    trait :with_program_title do
      program_title do
        t = [
            "#{Faker::Commerce.department}",
          "#{Faker::Hacker.ingverb} the #{[Faker::Hacker.adjective, Faker::Commerce.color].sample} #{Faker::Hacker.noun}",
          "#{Faker::Name.name}",
          "#{Faker::Name.name} goes #{Faker::Hacker.ingverb} with #{Faker::Name.name}",
          "#{Faker::Hacker.noun}",
          "#{Faker::Hacker.noun.pluralize}",
          "#{[Faker::Hacker.adjective + ' ', ''].sample}#{Faker::Commerce.product_name.pluralize} of #{Faker::Address.city}",
          ].sample

        t.titleize
      end
    end
    
    trait :with_date_portrayed do
      after(:build) do |pbcore, evaluator|
        pbcore.coverage.date_portrayed = "4/15/1970"
      end
    end
  end
end
