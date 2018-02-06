# borrowed (liberally) from
# http://vladigleba.com/blog/2014/04/10/deploying-rails-apps-part-6-writing-capistrano-tasks/

namespace :deploy do
  desc "upload database.yml"
  task :upload_database_yml do
    on roles(:app) do
      execute "mkdir -p #{shared_path}/config"
      upload! StringIO.new(File.read("config/database.yml")), "#{shared_path}/config/database.yml"
    end
  end

  desc "upload secrets.yml"
  task :upload_secrets_yml do
    on roles(:app) do
      execute "mkdir -p #{shared_path}/config"
      upload! StringIO.new(File.read("config/secrets.yml")), "#{shared_path}/config/secrets.yml"
    end
  end

  before 'deploy:check:linked_files', 'deploy:upload_database_yml'
  before 'deploy:check:linked_files', 'deploy:upload_secrets_yml'
end

