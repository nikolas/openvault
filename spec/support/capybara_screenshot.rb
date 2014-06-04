require 'capybara-screenshot/rspec'

Capybara::Screenshot.autosave_on_failure = false

RSpec.configure do |c|
  c.before(:each) do |example|
    Capybara::Screenshot.autosave_on_failure = example.metadata[:screenshot]
  end
end