require 'spec_helper'

describe CustomCollectionItems do
  
  before :each do
    @u = create(:user, role: 'scholar')
    @cc = create(:custom_collection, user_id: @u.id)
    @cci = create(:custom_collection_item, custom_collection_id: @cc.id)
  end
  
  it "should have be valid with all attributes" do
    @cci.should be_valid
  end
  
  it "should be invalid without a cat_slug" do
    build(:custom_collection_item, cat_slug: nil).should_not be_valid
  end
  
  it "should be invalid without a custom_collections_id" do
    build(:custom_collection_item, custom_collection_id: nil).should_not be_valid
  end
  
  it "should be ensure hash of annotations" do
    build(:custom_collection_item, annotations: 'testing fail').should be {'testing fail'}
  end
  
end
