# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  #create hash for annotations
  annotate = ActiveSupport::HashWithIndifferentAccess.new
  annotate[:test] = "123456"
  
  factory :custom_collection_item, :class => 'CustomCollectionItem' do
    openvault_asset_pid "org.wgbh.mla:gh93hg75d"
    custom_collection_id 1
    annotations annotate
  end
end
