namespace :elc do
  desc "import data from git repository (using git_source=<url>)"
  task :import_remote => :environment do
    fail("No source provided with ENV['git_source']") unless ENV['git_source']
  end
end