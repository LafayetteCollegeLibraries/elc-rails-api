# config valid for current version and patch releases of Capistrano
lock "~> 3.10.1"

set :application, "elc-api"
set :repo_url, "git@github.com:LafayetteCollegeLibraries/elc-rails-api.git"
set :data_git_source, "git@github.com:LafayetteCollegeLibraries/easton-library-company-data.git"
set :deploy_to, "/opt/elc-api"

# rbenv config
set :rbenv_type, :user
set :rbenv_ruby, '2.4.3'

# rails config
set :conditionally_migrate, false

# add rails shared dirs/files
append :linked_dirs, 'log', 'tmp/pids', 'tmp/cache', 'tmp/sockets'
append :linked_files, 'config/database.yml', 'config/secrets.yml'

# option to deploy without importing data
set :skip_data_import, false