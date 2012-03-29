$:.unshift(File.expand_path('./lib', ENV['rvm_path']))
require 'rvm/capistrano'

set :rvm_ruby_string, 'ruby-1.9.3-p0@gold'
set :rvm_type, :user
require 'bundler/capistrano'

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

