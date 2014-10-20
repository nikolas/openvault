FactoryGirl.define do
  
  factory :org do

    name { Faker::Company.name }
    desc do
      bs = []
      rand(2..5).times{ bs << Faker::Company.bs }
      last_bs = bs.pop
      "We " + bs.join(', ') + ' and ' + last_bs
    end

  end
end