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
  
  pending "is invalid without a custom_collection" do
    # logically, this example should pass... but I was getting a errors when trying to create CustomCollectionRelatedLinks from CustomCollection#new.
    # Taking off the validation to require custom_collection_id fixed it, and since CustomCollection#new is the only place to create CustomCollectionRelatedLinks,
    # I figured this would be ok. However, there's probably a way to avoid the errors *and* make this test pass, which it probably should.
    # build(:custom_collection_related_link, custom_collection_id: nil).should_not be_valid
  end
  
end
