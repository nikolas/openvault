require 'bundler/capistrano'
require "rvm/capistrano"
set :rvm_ruby_string, "2.0"
before 'deploy', 'rvm:create_gemset'
set :application, "openvault"
set :deploy_to, "/wgbh/http/#{application}"
set :use_sudo, false 
set :rails_env,     "production"
set :repository,  "https://github.com/afred/openvault.git"
set :scm, :git
set :scm_username , "afred"
set :user, "openvault"
set :deploy_via, :remote_cache
set :keep_releases, 3


set :branch, fetch(:branch, "development")

# set :bundle_dir, ''
# set :bundle_flags, '--system --quiet'

server "lsopenvault01.wgbh.org", :app, :web, :db, :primary => true

before "deploy:setup", "db:configure"
before  "deploy:assets:precompile", "db:symlink"
before 'deploy:assets:precompile', 'deploy:migrate'

after 'deploy:update_code', 'deploy:symlink_uploads'

namespace :deploy do
  task :start do ; end
  task :stop do ; end
  task :restart, :roles => :app, :except => { :no_release => true } do
    run "#{try_sudo} touch #{File.join(current_path,'tmp','restart.txt')}"
    #run "rake jetty:restart"
  end


  desc "symlink the uploads folder"
  task :symlink_uploads do
    run "ln -nfs #{shared_path}/public/uploads #{latest_release}/public/uploads"
  end

end

namespace :db do
  desc "Create database yaml in shared path"
  task :configure do
    set :database_username do
      "ov2"
    end
 
    set :database_password do
      Capistrano::CLI.password_prompt "Database Password: "
    end
 
    db_config = <<-EOF
      base: &base
        adapter:  mysql2
        host:     localhost
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
 
  desc "Make symlink"
  task :symlink do
    run "ln -nfs #{shared_path}/config/database.yml #{latest_release}/config/database.yml"
    run "ln -nfs #{shared_path}/jetty #{latest_release}/jetty"
    run "cp -f ~/#{application}_application.yml #{release_path}/config/application.yml"
  end
end