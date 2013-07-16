FactoryGirl.define do

  # A factory for instances of User model.
  factory :user do

    # the fake user has arbitrary name, email, and passowrd.
    first_name { Faker::Name.first_name }
    last_name { Faker::Name.last_name }
    email { "#{first_name}_#{last_name}@#{Faker::Internet.domain_name}".downcase }
    
    # NOTE: The user that is created by this factory will NOT have a password nor password_confirmation
    # for attr_accessors. When the 
    password { Faker::Lorem.characters 8 }
    password_confirmation { "#{password}" }

    # NOTE: you can use Faker::config.locale to create users from different countries.
    # see https://github.com/stympy/faker
    postal_code { Faker::Address::postcode }
    country 'Albania'
    role 'member'
    
    # the fake user agrees to terms and conditions, and wants to hear all about WGBH's Media Library and Archives
    terms_and_conditions true
    mla_updates true
  end
end