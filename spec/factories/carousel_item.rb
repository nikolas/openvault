# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :carousel_item do
    title Faker::Lorem.sentence(word_count = 4)
    body Faker::Lorem.paragraph(sentence_count = 4)
    url 'http://www.google.com'
    enabled true
    position 1
    image { File.open(File.join(Rails.root, '/spec/factories/files/test_jpg.jpg')) }
  end
end
