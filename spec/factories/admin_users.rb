# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :admin_user do
    
    email { "#{first_name}_#{last_name}@#{Faker::Internet.domain_name}".downcase }
    
    password { Faker::Lorem.characters 8 }
    password_confirmation { "#{password}" }
    
  end
end
