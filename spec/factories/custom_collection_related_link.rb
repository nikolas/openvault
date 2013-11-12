FactoryGirl.define do
  factory :custom_collection_related_link do
    link {Faker::Internet.url}
    desc {Faker::Lorem.paragraph}
    custom_collection_id { FactoryGirl.create(:custom_collection).id }
  end
end
