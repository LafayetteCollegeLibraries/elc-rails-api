# config valid for current version and patch releases of Capistrano
lock "~> 3.10.1"

set :application, "elc-api"
set :repo_url, "git@github.com:LafayetteCollegeLibraries/elc-rails-api.git"
set :deploy_to, "/opt/elc-api"

# rvm config
set :rvm_type, 'user'
set :rvm_ruby_version, '2.4.3'

# rails config
set :conditionally_migrate, false

# add rails shared dirs/files
append :linked_dirs, 'log', 'tmp/pids', 'tmp/cache', 'tmp/sockets'
append :linked_files, 'config/database.yml', 'config/secrets.yml'
