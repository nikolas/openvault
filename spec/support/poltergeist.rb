require 'capybara/poltergeist'

Capybara.register_driver :poltergeist do |app|
  options = {
    inspector: true,
    js_errors: false,
    timeout: ENV["CI"] ? 180 : 30,
    phantomjs_logger: StringIO.new,
    logger: nil,
    phantomjs_options: ['--load-images=no', '--ignore-ssl-errors=yes']    
  }

  puts "\n\nPOLTERGEIST OPTIONS = #{options}\n\n"

  Capybara::Poltergeist::Driver.new(app, options)
end

Capybara.current_driver = :poltergeist
Capybara.javascript_driver = :poltergeist

RSpec.configure do |c|
  new_symbol = "#{Capybara.javascript_driver.to_s}_broken".to_sym
  c.filter_run_excluding new_symbol => true
end