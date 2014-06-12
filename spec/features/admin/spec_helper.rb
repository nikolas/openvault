include Warden::Test::Helpers
Warden.test_mode!

require 'features/admin/admin_custom_collection_steps'

RSpec.configure do |config|
  config.include AdminCustomCollectionSteps
  config.include ActiveAdmin::CustomCollectionsHelper
end