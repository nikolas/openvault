# Link the latest release to any existing google analytics initializer
after 'deploy:update_code', 'link_shared:initializer:google_analytics'

namespace :deploy do
  desc 'Set Google Analytics ID'
  task :set_ga_id, roles: :app do
    set(:ga_id, Capistrano::CLI.ui.ask("Enter the Google Analytics account ID: "))

    file_contents = <<-EOS
# Google Analytics account ID
ENV['GA_TRACKING_ID'] = '#{ga_id}'
EOS

    put file_contents, "#{shared_path}/config/initializers/google_analytics.rb"
    link_shared.initializer.google_analytics
    restart
  end
end

namespace :link_shared do
  namespace :initializer do
    task :google_analytics do
      shared = "#{shared_path}/config/initializers/google_analytics.rb"
      symlink = "#{latest_release}/config/initializers/google_analytics.rb"
      run "test -f #{shared} && ln -nfs #{shared} #{symlink} || echo 'skipping symlink'"
    end
  end
end