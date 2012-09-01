set :rvm_ruby_string, '1.9.2p320'

# main details
set :application, "turbi"
role :web, "199.231.86.14"
role :app, "199.231.86.14"
role :db,  "199.231.86.14", :primary => true

# server details
default_run_options[:pty] = true
ssh_options[:forward_agent] = true
set :deploy_to, "/var/www/turbi"
set :deploy_via, :remote_cache
set :user, "root"
set :use_sudo, false


# repo details
set :scm, :git
set :scm_username, "passenger"
set :use_sudo, false
set :repository, "git@codeplane.com:startupdevrumble/startup-ideias.git"
set :branch, "master"
set :git_enable_submodules, 1

# tasks
namespace :deploy do
  task :start, :roles => :app do
    run "touch #{current_path}/tmp/restart.txt"
  end

  task :stop, :roles => :app do
    # Do nothing.
  end

  desc "Restart Application"
  task :restart, :roles => :app do
    run "touch #{current_path}/tmp/restart.txt"
  end
end


before 'deploy:restart', 'deploy:migrate'
after  'deploy',         'deploy:cleanup'

require "rvm/capistrano"
require "bundler/capistrano"
load 'deploy/assets'
