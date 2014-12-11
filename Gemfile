source 'https://rubygems.org'

gem 'rails', '~>3.2.14'

gem 'mysql2', "~>0.3.11"

# Gems used only for assets and not required
# in production environments by default.
group :assets do
  gem 'sass-rails',   '~> 3.2.3'
  gem 'coffee-rails', '~> 3.2.1'
  gem 'compass'
  gem 'compass-rails'
  gem 'uglifier', '>= 1.0.3'
end

group :test do
  # functional testing stuff
  gem 'pry'
  gem 'rspec'
  gem 'awesome_print'
  gem 'rspec-rails'

  # test data stuff
  gem 'factory_girl_rails'
  # gem 'faker', github: 'stympy/faker'
  gem 'faker', github: 'afred/faker', branch: 'for-openvault'

  # acceptance testing stuff
  gem 'capybara'
  gem 'capybara-screenshot'
  gem 'poltergeist'
  gem 'phantomjs'
  gem 'database_cleaner'
  gem 'email_spec'
  gem 'selenium-webdriver'
  gem 'launchy'
  
  # stuff to autorun test
  gem 'guard', '>= 2.6.0'
  gem 'guard-rspec', '>= 4.2.8'
  gem 'rb-fsevent', '~> 0.9'
  
  # measure coverage
  gem 'simplecov', :require => false
end

group :development do
  gem 'sextant'
  gem 'capistrano'
  gem 'rvm-capistrano'

  # There's a bug in net-ssh that causes a failure during capistrano deployments.
  # Failure is that it will fail to connect to remote server without asking for username or password.
  # Pinning to 2.7.x fixes it.
  gem 'net-ssh', "~>2.7.0"
end

gem 'jquery-rails', "2.3.0"

gem 'blacklight'
gem 'hydra', '6.1.0'
gem 'hydra-head'
gem 'oai'
gem 'jettywrapper'

# To use Jbuilder templates for JSON
# gem 'jbuilder'

# Use unicorn as the app server
# gem 'unicorn'

gem 'state_machine'
gem 'figaro'
gem "unicode", :platforms => [:mri_18, :mri_19]
gem "devise"
gem "devise-guests", "~> 0.3"
gem "bootstrap-sass"
gem "font-awesome-rails", "~> 4.0.0"
gem "cancan"
gem 'carrierwave'
gem 'activeadmin', "~> 0.6.0"
gem "mini_magick"
gem 'simple_form'
gem 'country_select', '~> 1.3.1'
gem 'acts_as_list'
gem 'activeadmin-sortable'
gem 'active_admin_editor'
gem "bootstrap-wysihtml5-rails", "~> 0.3.1.23"
gem 'pdf-reader'
gem "acts-as-taggable-on", :git => 'https://github.com/mbleigh/acts-as-taggable-on.git'
gem "acts_as_commentable", :git => 'https://github.com/jackdempsey/acts_as_commentable.git'
gem 'twitter'
gem "twitter-text", "~> 1.7.0"
gem "nested_form"
#gem 'hydra-collections'
gem "escape_utils"
gem 'rack-cache', :require => 'rack/cache'
gem 'byebug', groups: [:development, :test], :platform => :ruby_20
