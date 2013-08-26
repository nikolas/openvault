FactoryGirl.define do

  # A factory for instances of Custom Collections model.
  factory :custom_collection do


    name { Faker::Name.title }
    summary { Faker::Lorem.paragraph }
    user_id { FactoryGirl.create(:user, role: 'scholar').id }
    
    
  end
end