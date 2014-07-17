# This file is copied to spec/ when you run 'rails generate rspec:install'
ENV["RAILS_ENV"] ||= 'test'
require File.expand_path("../../config/environment", __FILE__)
require 'rspec/rails'
# require 'rspec/autorun'
require 'capybara/rspec'
require 'fixtures'
require 'openvault'

Capybara.default_driver = :poltergeist
Capybara.javascript_driver = :poltergeist
Capybara.default_wait_time = 5

# Requires supporting ruby files with custom matchers and macros, etc,
# in spec/support/ and its subdirectories.
Dir[Rails.root.join("spec/support/**/*.rb")].each {|f| require f}

# Require custom capybara feature steps
Dir[Rails.root.join("spec/features/steps/**/*.rb")].each { |f| require f }

RSpec.configure do |config|
  # ## Mock Framework
  #
  # If you prefer to use mocha, flexmock or RR, uncomment the appropriate line:
  #
  # config.mock_with :mocha
  # config.mock_with :flexmock
  # config.mock_with :rr

  # If true, the base class of anonymous controllers will be inferred
  # automatically. This will be the default behavior in future versions of
  # rspec-rails.
  config.infer_base_class_for_anonymous_controllers = false

  # This is needed so we don't have to add metadata for the type of spec. Use Rails conventions instead.
  config.infer_spec_type_from_file_location!

  # Run specs in random order to surface order dependencies. If you find an
  # order dependency and want to debug it, you can fix the order by providing
  # the seed, which is printed after each run.
  #     --seed 1234
  config.order = "random"

  # Include some stuff
  config.include FactoryGirl::Syntax::Methods
  config.include EmailSpec::Helpers
  config.include EmailSpec::Matchers

  config.include CommonSteps
  config.include UserSteps
  config.include SearchSteps
  config.include CustomCollectionSteps

  config.use_transactional_fixtures = false

  config.before(:suite) do
    # DatabaseCleaner.strategy = :truncation
    DatabaseCleaner.clean_with :truncation
  end

  config.fixture_path = File.expand_path("../fixtures", __FILE__)

  config.before(:context) do
    ActiveFedora::Base.destroy_all
    DatabaseCleaner.clean
  end
end

module Rack
  module Utils
    def escape(s)
      CGI.escape(s.to_s)
    end
    def unescape(s)
      CGI.unescape(s)
    end
  end
end
