require 'spec_helper'

# NOTE: FactoryGirl shortcut methods (create, build, attributes_for, etc.) are included in spec_helper.rb

describe CustomCollection do

  describe "factory for :custom_collection" do
    it "makes a valid CustomCollection" do
      build(:custom_collection).should be_valid
    end

    it "is owned by a saved User" do
      cc = build(:custom_collection)
      cc.owner.should be_a User
      cc.owner.should_not be_a_new User
    end

    it "is invalid without an owner" do
      build(:custom_collection, owner: nil).should_not be_valid
    end

    it "is invalid when user is not a scholar" do
      member_user = create(:user)
      build(:custom_collection, owner: member_user).should_not be_valid
    end
    
    it "is invalid without a name" do
      build(:custom_collection, name: nil).should_not be_valid
    end
    
    it "is invalid without a summary"  do
      build(:custom_collection, summary: nil).should_not be_valid
    end

  end

  describe "factory for :custom_collection_owned_by_org" do
    it 'makes a valid CustomCollection' do
      build(:custom_collection_owned_by_org).should be_valid
    end

    it 'is owned by a saved Org' do
      cc = build(:custom_collection_owned_by_org)
      cc.owner.should be_a Org
      cc.owner.should_not be_a_new Org
    end
  end
  
  
  pending "has a valid vanity url" do
    # I scrapped this for now because I don't think that URL logic should go in the model,
    # but not sure how to implement it at the moment.
    # user = create(:user, first_name: 'John', last_name: 'Smith', role: 'scholar')
    # collection = create(:custom_collection, name: 'testing 1', owner: user)
    # collection.vanity_url.should eq("/scholar/john-smith/testing-1")
  end


  # TODO: put this creation logic into a factory
  it "creates a valid custom collection item" do
    collection = create(:custom_collection)
    v = Video.new
    v.save
    collection.add_collection_item(v.pid, "Video")
    collection.custom_collection_items[0].ov_asset['slug'].should eq(v.pid)
  end
  
end
