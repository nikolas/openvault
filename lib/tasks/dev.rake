require 'rspec/core'
require 'rspec/core/rake_task'
APP_ROOT="." # for jettywrapper
require 'jettywrapper'

namespace :dev do
  namespace :ci do
    desc "Prepare to run specs via continuous integration"
    task :prepare => ["jetty:clean", "hydra:jetty:config", "jetty:start", "db:migrate"]
  end
end
