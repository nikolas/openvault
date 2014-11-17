# Link the latest release to any existing basic http auth initializer
after 'deploy:update_code', 'link_shared:initializer:basic_http_auth'


namespace :deploy do
  desc 'Set basic http authentication'
  task :set_http_basic_auth, roles: :app do
    puts "Setting up basic http authentication..."
    set(:username, Capistrano::CLI.ui.ask("Enter a username: "))
    set(:http_password, Capistrano::CLI.password_prompt("Enter a password: "))

    username_constraint = /^[A-Za-z0-9 _\-!@$%^&*+=\(\)\[\]:;"<>,\.\?\/#]{1,20}$/
    password_constraint = /^[A-Za-z0-9 _\-!@$%^&*+=\(\)\[\]:;"<>,\.\?\/#]{6,20}$/

    raise "Username must match this regex: #{username_constraint.inspect}" unless username =~ username_constraint
    raise "Password must match this regex: #{password_constraint.inspect}" unless password =~ password_constraint

    file_contents = <<-EOS
# Environment varaibles to be use for basic HTTP authentication.
ENV['HTTP_BASIC_AUTH_USER'] = '#{username}'
ENV['HTTP_BASIC_AUTH_PASSWORD'] = '#{http_password}'
EOS

    put file_contents, "#{shared_path}/config/initializers/basic_http_auth.rb"
    link_shared.initializer.basic_http_auth
    restart
  end

  desc 'Remove basic http authentication'
  task :remove_http_basic_auth, roles: :app do
    # remove the symlink
    run "rm #{latest_release}/config/initializers/basic_http_auth.rb"

    # remove the shared file
    run "rm #{shared_path}/config/initializers/basic_http_auth.rb"
  end
end

namespace :link_shared do
  namespace :initializer do
    desc "Link to shared initializer for basic http auth"
    task :basic_http_auth do
      shared = "#{shared_path}/config/initializers/basic_http_auth.rb"
      symlink = "#{latest_release}/config/initializers/basic_http_auth.rb"
      run "test -f #{shared} && ln -nfs #{shared} #{symlink} || echo 'skipping symlink'"
    end
  end
end