##### Requirement's #####
require 'bundler/capistrano'
require 'capistrano/ext/multistage'
require 'capistrano-unicorn'
require 'capistrano/sidekiq'


##### Use the asset-pipeline #####
set :assets_role, [ :app ]
load 'deploy/assets'

##### Stages #####
set :stages, %w(production)
set :rails_env, defer{ stage }

##### Constant variables #####
set :application,         "cohabitat_discourse"
set :deploy_to,           defer { "/home/rails/#{application}_#{stage}" }
set :user,                defer { "#{application}_#{stage}" }
set :use_sudo, false

##### Default variables #####
set :keep_releases, 3

##### Repository Settings #####
set :scm,        :git
set :repository, "git@github.com:Cohabitat/discourse.git"

##### Additional Settings #####
set :ssh_options, { :forward_agent => true }

#### Unicorn settings ####
set :unicorn_env,    defer { stage }
set :unicorn_pid,    defer { "/home/rails/#{application}_#{stage}/run/appserver.pid" }

#### Sidekiq settings ####
set :sidekiq_env,    defer { stage }
set :sidekiq_pid,    defer { "/home/rails/#{application}_#{stage}/run/sidekiq.pid" }

#### Roles #####
# See Stages

##### Overwritten and changed default capistrano tasks #####
namespace :deploy do
  # Restart Application
  desc "Restart app"
  task :restart, :roles => :app, :except => { :no_release => true } do
    unicorn::duplicate
  end

  desc "Reload the database with seed data"
  task :seed, :roles => [ :db ] do
    run "cd #{current_path}; bundle exec rake db:seed RAILS_ENV=#{rails_env}"
  end

  desc "Protedted dir symlink"
  task :protected_symlink, :roles => :app do
    run "mkdir -p #{shared_path}/protected"
    run "ln -nfs #{shared_path}/protected #{release_path}/protected"
  end  

  desc "Additional Symlinks"
  task :additional_symlink, :roles => :app do
    [ "database.yml", "unicorn.rb" ].each do |shared_config_file|
      run "ln -nfs #{shared_path}/config/#{shared_config_file} #{release_path}/config/#{shared_config_file}"
    end
  end  
end

##### After and Before Tasks #####
before "deploy:assets:precompile", "deploy:protected_symlink"
before "deploy:assets:precompile", "deploy:additional_symlink"
after  "deploy:restart",           "deploy:cleanup"

require './config/boot'
