require 'spec_helper'

# NOTE: FactoryGirl shortcut methods (create, build, attributes_for, etc.) are included in spec_helper.rb

describe CustomCollection do


  it 'has a valid factory' do
    build(:custom_collection).should be_valid
  end

  it 'is invalid without an owner' do
    build(:custom_collection, owner: nil).should_not be_valid
  end

  it 'is valid if owner is a User who is a scholar' do
    build(:custom_collection, owner: build(:user, role: "scholar")).should be_valid
  end

  it 'is valid if owner is an Org' do
    build(:custom_collection, owner: build(:org)).should be_valid
  end

  it 'is invalid if User is not a scholar' do
    build(:custom_collection, owner: build(:user, role: "member")).should_not be_valid
  end

  it "is invalid without a name" do
    build(:custom_collection, name: nil).should_not be_valid
  end
  
  it "is invalid without a summary"  do
    build(:custom_collection, summary: nil).should_not be_valid
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

  describe 'has many Users' do
    before :all do
      @custom_collection = FactoryGirl.create(:custom_collection)
      @users = FactoryGirl.create_list(:user, 5)
    end

    it "should handle adding multiple User instances via #collabs" do
      @users.each { |user| @custom_collection.collabs << user }
      @custom_collection.collabs.count.should == 5
    end
  end
  
end
