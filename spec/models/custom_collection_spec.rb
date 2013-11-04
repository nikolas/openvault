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
  
  it "has a valid vanity url" do
    user = create(:user, first_name: 'John', last_name: 'Smith', role: 'scholar')
    collection = create(:custom_collection, name: 'testing 1', user_id: user.id)
    collection.van_url.should eq("/scholar/john-smith/testing-1")
  end
  
  it "creates a valid custom collection item" do
    user = create(:user, role: 'scholar')
    collection = create(:custom_collection, user_id: user.id)
    v = Video.new
    v.save
    collection.add_collection_item(v.pid, "Video")
    collection.custom_collection_items[0].ov_asset['slug'].should eq(v.pid)
  end
  
end
