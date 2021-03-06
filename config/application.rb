require File.expand_path('../boot', __FILE__)

require 'rails/all'
require "sass-rails"

if defined?(Bundler)
  # If you precompile assets before deploying to production, use this line
  Bundler.require(*Rails.groups(:assets => %w(development test)))
  # If you want your assets lazily compiled in production, use this line
  # Bundler.require(:default, :assets, Rails.env)
end

module Openvault
  class Application < Rails::Application
    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration should go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded.
    config.sass.load_paths ||= []
    config.sass.load_paths << "#{Rails.root}/app/assets/stylesheets"
    config.sass.load_paths << "#{Gem.loaded_specs['compass'].full_gem_path}/frameworks/compass/stylesheets"

    # A little tweak to load order to ensure we get the right version of GenericFile.
    #config.railties_order = [:main_app, BawstunCommons::Engine, Sufia::Engine, :all]

    #change scaffold to build rspec tests
    config.generators do |g|
      g.test_framework :rspec,
        :fixtures => false,
        :view_specs => false,
        :helper_specs => false,
        :routing_specs => false,
        :controller_specs => true,
        :request_specs => true
      g.factory_girl true
    end
    # Only needed if we're using BawstunCommons with Sufia.
    # config.railties_order = [:main_app, BawstunCommons::Engine, Sufia::Engine, :all]

    # Custom directories with classes and modules you want to be autoloadable.
    config.autoload_paths += Dir["#{config.root}/app/{models,controllers}/*/**/"]

    # Only load the plugins named here, in the order given (default is alphabetical).
    # :all can be used as a placeholder for all plugins not explicitly named.
    # config.plugins = [ :exception_notification, :ssl_requirement, :all ]

    config.cache_store = :memory_store, { expires_in: 60*60*24*7, race_condition_ttl: 60 }
    
    # Rack Cache
    # config.middleware.use Rack::Cache,
    #   :verbose => true,
    #   :metastore   => 'file:/var/cache/rack/meta',
    #   :entitystore => 'file:/var/cache/rack/body'

    # Activate observers that should always be running.
    # config.active_record.observers = :cacher, :garbage_collector, :forum_observer

    # Set Time.zone default to the specified zone and make Active Record auto-convert to this zone.
    # Run "rake -D time" for a list of tasks for finding time zone names. Default is UTC.
    # config.time_zone = 'Central Time (US & Canada)'

    # The default locale is :en and all translations from config/locales/*.rb,yml are auto loaded.
    # config.i18n.load_path += Dir[Rails.root.join('my', 'locales', '*.{rb,yml}').to_s]
    config.i18n.default_locale = :en

    # Configure the default encoding used in templates for Ruby 1.9.
    config.encoding = "utf-8"

    # Configure sensitive parameters which will be filtered from the log file.
    config.filter_parameters += [:password]

    # Enable escaping HTML in JSON.
    config.active_support.escape_html_entities_in_json = true

    # Use SQL instead of Active Record's schema dumper when creating the database.
    # This is necessary if your schema can't be completely dumped by the schema dumper,
    # like if you have constraints or database-specific column types
    # config.active_record.schema_format = :sql

    # Enforce whitelist mode for mass assignment.
    # This will create an empty whitelist of attributes available for mass-assignment for all models
    # in your app. As such, your models will need to explicitly whitelist or blacklist accessible
    # parameters by using an attr_accessible or attr_protected declaration.
    config.active_record.whitelist_attributes = true

    # Enable the asset pipeline
    config.assets.enabled = true
    # Default SASS Configuration, check out https://github.com/rails/sass-rails for details
    config.assets.compress = !Rails.env.development?

    # Version of your assets, change this if you want to expire all your assets
    config.assets.version = '1.0'

    config.application_name = "Open Vault"
    config.organization_name = "WGBH Media Library and Archives"
  end
end
