require "bundler/capistrano" 

set :application, "WGBH Openvault"
set :deply_to, "/wgbh/http/open_vault"
set :user, "jwilcox"

set :repository,  "git@github.com:afred/openvault.git"
set :scm, :git
set :scm_username , "joshuaswilcox"
#this allows you to choose a branch in the command line or default to master with 'cap -S branch=branchname deploy'
set :branch, fetch(:branch, "search_feature")
#tells is to do resuse a single remote git clone
set :deploy_via, :remote_cache

# set :scm, :git # You can set :scm explicitly or Capistrano will make an intelligent guess based on known version control directory names
# Or: `accurev`, `bzr`, `cvs`, `darcs`, `git`, `mercurial`, `perforce`, `subversion` or `none`

# role :web, "your web-server here"                          # Your HTTP server, Apache/etc
# role :app, "your app-server here"                          # This may be the same as your `Web` server
# role :db,  "your primary db-server here", :primary => true # This is where Rails migrations will run
# role :db,  "your slave db-server here"
server "lsopenvault01.wgbh.org", :app, :web, :db, :primary => true

# if you want to clean up old releases on each deploy uncomment this:
# after "deploy:restart", "deploy:cleanup"

# if you're still using the script/reaper helper you will need
# these http://github.com/rails/irs_process_scripts

after 'deploy:update_code', 'deploy:migrate'

# If you are using Passenger mod_rails uncomment this:
namespace :deploy do
  task :start do ; end
  task :stop do ; end
  task :restart, :roles => :app, :except => { :no_release => true } do
    run "#{try_sudo} touch #{File.join(current_path,'tmp','restart.txt')}"
  end
end