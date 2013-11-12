require 'spec_helper'

describe CustomCollectionRelatedLink do
  it "has a valid factory" do
    create(:custom_collection_related_link).should be_valid
  end
  
  it "is invalid without a link" do
    build(:custom_collection_related_link, link: nil).should_not be_valid
  end
  
  it "is invalid without a valid url" do
    build(:custom_collection_related_link, link: 'asdfasdf').should_not be_valid
  end
  
  it "is invalid without a desc" do
    build(:custom_collection_related_link, desc: nil).should_not be_valid
  end
  
  it "is invalid without a custom_collection" do
    build(:custom_collection_related_link, custom_collection_id: nil).should_not be_valid
  end
  
end
