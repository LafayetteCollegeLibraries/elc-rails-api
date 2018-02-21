namespace :elc do
  desc 'seeds the database and loads remote data'
  task seed_and_import: %i[invoke_seed_db invoke_import_data]

  task :invoke_seed_db do
    on roles(:app) do
      within release_path do
        with rails_env: fetch(:rails_env) do
          execute :rake, 'db:seed' unless fetch(:skip_data_import)
        end
      end
    end
  end

  task :invoke_import_data do
    on roles(:app) do
      within release_path do
        with rails_env: fetch(:rails_env) do
          unless fetch(:skip_data_import)
            git_source = "git_source=#{fetch(:data_git_source)}"
            execute :rake, "elc:import_remote #{git_source}"
          end
        end
      end
    end
  end
end

after :deploy, 'elc:seed_and_import'
