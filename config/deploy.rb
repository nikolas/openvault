require 'bundler/capistrano'
#require "rvm/capistrano"
#set :rvm_ruby_string, :local 
#before 'deploy', 'rvm:create_gemset'
set :application, "openvault"
set :deploy_to, "/wgbh/http/#{application}"
set :use_sudo, false 
set :rails_env,     "production"
set :repository,  "https://github.com/afred/openvault.git"
set :scm, :git
set :scm_username , "joshuaswilcox"
set :user, "openvault"
set :deploy_via, :remote_cache
set :keep_releases, 3


set :branch, fetch(:branch, "development")

set :bundle_dir, ''
set :bundle_flags, '--system --quiet'

server "lsopenvault01.wgbh.org", :app, :web, :db, :primary => true

before "deploy:setup", "db:configure"
before  "deploy:assets:precompile", "db:symlink"
before 'deploy:assets:precompile', 'deploy:migrate'

# If you are using Passenger mod_rails uncomment this:
namespace :deploy do
  task :start do ; end
  task :stop do ; end
  task :restart, :roles => :app, :except => { :no_release => true } do
    run "#{try_sudo} touch #{File.join(current_path,'tmp','restart.txt')}"
  end
end

namespace :db do
  desc "Create database yaml in shared path"
  task :configure do
    set :database_username do
      "ov_db_user"
    end
 
    set :database_password do
      Capistrano::CLI.password_prompt "Database Password: "
    end
 
    db_config = <<-EOF
      base: &base
        adapter:  mysql
        host:     localhost
        encoding: unicode
        pool:     5
        username: #{database_username}
        password: #{database_password}
 
      production:
        database: #{application}_production
        <<: *base
    EOF
 
    run "mkdir -p #{shared_path}/config"
    put db_config, "#{shared_path}/config/database.yml"
  end
 
  desc "Make symlink for database yaml"
  task :symlink do
    run "ln -nfs #{shared_path}/config/database.yml #{latest_release}/config/database.yml"
  end
end