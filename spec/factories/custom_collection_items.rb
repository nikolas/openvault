# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  #create hash for annotations
  annotate = ActiveSupport::HashWithIndifferentAccess.new
  annotate[:test] = "123456"
  
  factory :custom_collection_item, :class => 'CustomCollectionItems' do
    cat_slug "MyString"
    custom_collection_id 1
    annotations annotate
  end
end
