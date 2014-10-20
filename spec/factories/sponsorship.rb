FactoryGirl.define do

  factory :sponsorship do

    # Fake IDs for associated models. If you want real objects here, pass them in to the factory like so:
    #   FactoryGirl.create(:sponsorship, user: create(:user), artifact: create(:artifact))
    user_id 11111
    artifact_id 11111

  end
end