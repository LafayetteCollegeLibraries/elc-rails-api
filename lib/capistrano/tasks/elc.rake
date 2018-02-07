namespace :elc do
  desc "seeds the database and loads remote data"
  task :seed_and_import => [:invoke_seed_db, :invoke_import_data]

  task :invoke_seed_db do
    on roles(:app) do
      execute "bundle exec rails db:seed"
    end
  end

  task :invoke_import_data do
    on roles(:app) do
      execute "bundle exec rails elc:import_remote git_remote=#{fetch(:data_git_source)}"
    end
  end

  after :deploy, 'elc:seed_and_import'
end