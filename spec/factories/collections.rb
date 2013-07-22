# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :collection do
    name Faker::Lorem.sentence(word_count = 4)
    summary Faker::Lorem.paragraph(sentence_count = 4)
    display_in_carousel '1'
  end
end
