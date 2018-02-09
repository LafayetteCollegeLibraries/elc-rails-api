# with many many thanks to:
# https://stackoverflow.com/a/26345807

namespace :server do
  desc 'start the rails server as a daemon'
  task :start do
    on roles(:app) do
      within release_path do
        pid_path = File.join(shared_path, 'tmp', 'pids', 'server.pid')
        next if test "[ -f #{pid_path} ]"

        execute :rails, 'server --daemon --binding=0.0.0.0 --port=3000'
      end
    end
  end

  task :stop do
    on roles(:app) do
      pid_path = File.join(shared_path, 'tmp', 'pids', 'server.pid')
      next unless test "[ -f #{pid_path} ]"

      execute "((ls #{pid_path} && ps -p `cat #{pid_path}`) && kill -9 `cat #{pid_path}`) || true"
      execute "(ls #{pid_path} && /bin/rm #{pid_path}) || true"
    end
  end
end