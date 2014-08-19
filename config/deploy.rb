require 'bundler/capistrano'
require 'rvm/capistrano'


###############################################################################
# MULTISTAGE CONFIG - Set configuration for multi-stage deployment.
###############################################################################

set :stages, %w(staging)
set :default_stage, "staging"
require 'capistrano/ext/multistage'


###############################################################################
# COMMON CONFIG - Set configuration common to all stages and tasks
#   Config for specific stages should be set in config/deploy/name_of_stage.rb
###############################################################################

# General info
set :application, "openvault"
set :user, "openvault"
set :group, "wgbhtech"
set :deploy_to, "/wgbh/http/#{application}"
set :use_sudo, false
set :rails_env, "production"
set :keep_releases, 5

# Github
set :scm, :git
set :repository,  "https://github.com/afred/openvault.git"
set :scm_username , "afred"
set :branch, fetch(:branch, "development")
set :deploy_via, :remote_cache

# RVM
set :rvm_ruby_string, "2.0"
before 'deploy', 'rvm:create_gemset'

# SSH
default_run_options[:pty] = true
set :ssh_options, { :forward_agent => true }


###############################################################################
# HOOKS - Set up all the hooks to say what happens and when
###############################################################################
before "deploy:setup", "upload_shared:database_yml"

before 'deploy:assets:precompile', 'deploy:migrate'
before 'deploy:migrate', 'link_shared:database_yml'

# Symlink all other shared stuffs
after 'deploy:update_code', 'link_shared:application_yml'
after 'deploy:update_code', 'link_shared:uploads'
after 'deploy:upate_code', 'link_shared:blog'
after 'deploy:update_code', 'link_shared:jetty'
after 'deploy:update_code', 'link_shared:log'
after 'deploy:update_code', 'link_shared:static_content'
after 'deploy:update_code', 'link_shared:initializer:basic_http_auth'



after 'deploy:update', 'deploy:cleanup'

###############################################################################
# TASKS - Define all tasks for setup, deployment, etc.
###############################################################################


# Deployment Tasks
namespace :deploy do
  task :start do ; end
  task :stop do ; end
  task :restart, :roles => :app, :except => { :no_release => true } do
    run "touch #{File.join(current_path,'tmp','restart.txt')}"
  end

  desc 'Show deployed revision'
  task :revision, :roles => :app do
    run "cat #{current_path}/REVISION"
  end

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
    # run "ln -nfs #{shared_path}/config/initializers/basic_http_auth.rb #{current_release}/config/initializers/basic_http_auth.rb"
    link_shared.initializer.basic_http_auth
    restart
  end
end

namespace :link_shared do

  desc "Link to shared database config in latest release"
  task :database_yml do
    run "ln -nfs #{shared_path}/config/database.yml #{latest_release}/config/database.yml"
  end

  desc "Link to shared application config in latest release"
  task :application_yml do
    run "ln -nfs #{shared_path}/config/application.yml #{latest_release}/config/application.yml"
  end

  desc "Link to shared blog in latest release"
  task :blog do
    run "ln -nfs #{shared_path}/public/blog #{latest_release}/public/blog"
  end

  desc "Link to shared jetty instance in latest release"
  task :jetty do
    run "ln -nfs #{shared_path}/jetty #{latest_release}/jetty"
  end

  desc "Link to shared log in latest release"
  task :uploads do
    run "ln -nfs #{shared_path}/public/uploads #{latest_release}/public/uploads"
  end

  desc "Link to shared log in latest release"
  task :log do
    run "ln -nfs #{shared_path}/log #{latest_release}/log"
  end

  desc "Link to shared static content under public directory"
  task :static_content do
    run "ln -nfs #{shared_path}/public/mpot #{latest_release}/public/mpot"
    run "ln -nfs #{shared_path}/public/pdf #{latest_release}/public/pdf"
    run "ln -nfs #{shared_path}/public/logos #{latest_release}/public/logos"
    run "ln -nfs #{shared_path}/public/sfdb #{latest_release}/public/sfdb"
    run "ln -nfs #{shared_path}/public/img #{latest_release}/public/img"
  end

  namespace :initializer do
    desc "Link to shared initializer for basic http auth"
    task :basic_http_auth do
      run "test -f #{shared_path}/config/initializers/basic_http_auth.rb && ln -nfs #{shared_path}/config/initializers/basic_http_auth.rb #{latest_release}/config/initializers/basic_http_auth.rb"
    end
  end
end