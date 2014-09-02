FactoryGirl.define do

  # A factory for instances of User model.
  factory :user do
    # the fake user has arbitrary name, email, and passowrd.
    first_name { Faker::Name.first_name }
    last_name { Faker::Name.last_name }
    email { "#{first_name}_#{last_name}@#{Faker::Internet.domain_name}".downcase }

    # NOTE: The user that is created by this factory will NOT have a password nor password_confirmation
    # for attr_accessors. When the
    password { rand(10000..100000).to_s*8 }
    password_confirmation { |u| "#{u.password}" }

    bio { Faker::Lorem.characters(char_count = 300) }

    # NOTE: you can use Faker::config.locale to create users from different countries.
    # see https://github.com/stympy/faker
    postal_code { Faker::Address::postcode }
    country 'Albania'
    role 'member'
    # the fake user agrees to terms and conditions, and wants to hear all about WGBH's Media Library and Archives
    terms_and_conditions true
    mla_updates true
  end

  factory :scholar_user, parent: :user do
    role 'scholar'
  end

  factory :admin, parent: :user do
    admin true
  end

  factory :bioless_user, parent: :user do
    bio ""
  end

  factory :user_with_custom_collection, parent: :scholar_user do
    after(:create) do |user|
      user.save!
      5.times do |n|
        user.owned_collections << FactoryGirl.create(:custom_collection)
      end
    end
  end

end
