require 'spec_helper'

# NOTE: FactoryGirl shortcut methods (create, build, attributes_for, etc.) are included in spec_helper.rb

describe CustomCollection do
  
  it "has a valid factory" do
    create(:custom_collection).should be_valid
  end
  
  it "is invalid without a user_id" do
    build(:custom_collection, user_id: nil).should_not be_valid
  end
  
  it "is invalid when user is not a scholar" do
    member_user = create(:user)
    build(:custom_collection, user_id: member_user.id).should_not be_valid
  end
  
  it "is invalid without a name" do
    build(:custom_collection, name: nil).should_not be_valid
  end
  
  it "is invalid without a summary"  do
    build(:custom_collection, summary: nil).should_not be_valid
  end
  
end
