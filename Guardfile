# A sample Guardfile
# More info at https://github.com/guard/guard#readme

# Pattern for rspec:
#   pass a regex to watch()
#   if no block is given
#     runs rspec with the matched file
#   if a block is given
#     passes the regex matches to the block
#     runs rspec on filename(s) returned from block
guard 'rspec' do

  # Watches every *_spec.rb under spec/ dir, and by default, runs it.
  watch(%r{^spec/.+_spec\.rb$})

  # Watches anything under lib/ dir and runs rspec for corresponding spec/lib/*_spec.rb
  # NOTE: this will follow directories, e.g. changing lib/foo/bar.rb will run spec/lib/foo/bar_spec.rb
  watch(%r{^lib/(.+)\.rb$})     { |m| "spec/lib/#{m[1]}_spec.rb" }
  watch('spec/spec_helper.rb')  { "spec" }

  # Rails example
  watch(%r{^app/(.+)\.rb$})                           { |m| "spec/#{m[1]}_spec.rb" }
  watch(%r{^app/(.*)(\.erb|\.haml)$})                 { |m| "spec/#{m[1]}#{m[2]}_spec.rb" }
  watch(%r{^app/controllers/(.+)_(controller)\.rb$})  { |m| ["spec/routing/#{m[1]}_routing_spec.rb", "spec/#{m[2]}s/#{m[1]}_#{m[2]}_spec.rb", "spec/acceptance/#{m[1]}_spec.rb"] }
  watch(%r{^spec/support/(.+)\.rb$})                  { "spec" }
  watch('config/routes.rb')                           { "spec/routing" }
  watch('app/controllers/application_controller.rb')  { "spec/controllers" }

  # Capybara features specs
  watch(%r{^app/views/(.+)/.*\.(erb|haml)$})          { |m| "spec/features/#{m[1]}_spec.rb" }

  # Watch for factories in spec/models/factories/ and trigger model spec with the same name.
  # E.g. changeing spec/models/factories/user.rb triggers `rspec spec/models/user_spec.rb'
  # This assumes a 1-to-1 between factory and model spec. If that changes, then will need to change this line.
  watch(%r{^spec/factories/(.+)\.rb$})          { |m| "spec/models/#{m[1]}_spec.rb" }

  # Watches spec/fixtures/artesia_ingest/*.xml and runs spec/lib/openvault/ingester/artesia_spec.rb
  watch(%r{^spec/fixtures/artesia_ingest/(.+)\.xml$}) do |m| 
    [
      "spec/lib/openvault/ingester/artesia_spec.rb",
      "spec/lib/artesia/datastreams/uois_spec.rb",
      "spec/models/openvault_asset_spec.rb",
      "spec/models/artesia_ingest_spec.rb",
      "spec/models/datastream/uois_spec.rb"
    ]
  end
end