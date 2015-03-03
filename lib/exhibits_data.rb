# Require everything under the `exhibits_data/` directory.
Dir[File.join(File.dirname(__FILE__), 'exhibits_data', '*.rb')].each{ |exhibits_data_module| require exhibits_data_module }

module ExhibitsData; end