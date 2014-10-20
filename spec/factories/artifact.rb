FactoryGirl.define do

  factory :artifact do

    pid 'fake-fedora-pid'

    factory :digitization do
      type 'digitization'
    end

  end
end