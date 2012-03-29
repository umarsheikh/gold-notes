$:.unshift(File.expand_path('./lib', ENV['rvm_path']))
require 'rvm/capistrano'

set :rvm_ruby_string, 'ruby-1.9.3-p0@gold'
set :rvm_type, :user
require 'bundler/capistrano'
default_run_options[:pty] = true # if u run a command on server which requesta pwd, then this request gets forwarded to you
set :application, "gold-notes"
set :repository,  "."
set :scm, :none
ssh_options[:forward_agent] = true
set :deploy_to, "~/apps/gold-notes"
set :deploy_via, :copy_without_compression
set :use_sudo, false
set :bundle_without, [:development, :test, :cucumber]
set :bundle_flags, "--deployment"

role :web, ''
role :app, ''
role :db, '', :primary => true # This is where Rails migrations will run

after "deploy", "deploy:cleanup"

namespace :deploy do
  task :restart do
    run "touch #{current_path}/tmp/restart.txt"
  end
end

namespace :rvm do
  desc 'Trust rvmrc file'
  task :trust_rvmrc do
    run "rvm rvmrc trust #{current_release}"
  end
end

after "deploy:update_code", "rvm:trust_rvmrc"

after 'deploy:update_code', 'deploy:symlink_config_files'
namespace :deploy do
  desc "Symlinks the database.yml"
  task :symlink_config_files, :roles => :app do
    run "ln -nfs #{deploy_to}/shared/config/database.yml #{release_path}/config/database.yml"
    run "ln -nfs #{deploy_to}/shared/config/config.yml #{release_path}/config/config.yml"
  end
end

# the following is an example of how to have two deploys from the same project, one from Rails.root, 
# the one on top, and the other from Rails.root/utils/import/jenkins, as this requires the bundle 
# install to run, you will need to create an empty Gemfile in the utils/import/jenkins directory, and 
# as the symlinks wont be there in the deploy:symlink_config_files task, you will need to wrap those 
# creations is a block like: if release_path.match(/jenkins/) else end

namespace :deploy do
  after "deploy:jenkins", "deploy"
  after "deploy:jenkins_setup", "deploy:setup"
  desc "setup jenkins deployment directories before doing a jenkins deploy for first time"
  task :jenkins_setup, :roles => :app do
    configure_jenkins
  end
  desc "deploy the jenkins folder"
  task :jenkins, :roles => :app do
    configure_jenkins()
  end
  task :configure_jenkins, :roles => :app do
    set :application, "jenkins"
    set :repository,  "./utils/import/jenkins"
    set :deploy_to, "~/apps/jenkins"
    set :bundle_flags, "--quiet"
  end
end
