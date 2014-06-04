FactoryGirl.define do
  #create hash for annotations
  annotate = ActiveSupport::HashWithIndifferentAccess.new
  annotate[:test] = "123456"
  
  factory :custom_collection_item, :class => 'CustomCollectionItem' do
    openvault_asset_pid "changeme:gh93hg75d"
    custom_collection_id 1
    kind "Video"
    annotations annotate
  end
end
