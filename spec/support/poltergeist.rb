require 'capybara/poltergeist'

Capybara.register_driver :poltergeist do |app|
  options = { inspector: true, js_errors: false }
  options[:timeout] = ENV["CI"] ? 60 : 30
  Capybara::Poltergeist::Driver.new(app, options)
end

Capybara.current_driver = :poltergeist
Capybara.javascript_driver = :poltergeist

RSpec.configure do |c|
  new_symbol = "#{Capybara.javascript_driver.to_s}_broken".to_sym
  c.filter_run_excluding new_symbol => true
end