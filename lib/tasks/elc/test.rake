unless Rails.env.production?
  require 'rspec/core/rake_task'
  require 'rubocop/rake_task'

  namespace :elc do
    namespace :test do
      desc 'run rspec tests'
      RSpec::Core::RakeTask.new(:rspec) do |t|
        t.rspec_opts = ['--color', '--backtrace']
      end

      desc 'run rubocop'
      RuboCop::RakeTask.new(:rubocop) do |t|
        t.fail_on_error = true
      end

      desc 'run rubocop + rspec tests'
      task ci: :environment do
        Rake::Task['elc:test:rubocop'].invoke &&
          Rake::Task['elc:test:rspec'].invoke
      end
    end
  end
end
