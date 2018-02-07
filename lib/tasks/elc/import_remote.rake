require 'fileutils'
require 'rake'

namespace :elc do
  desc "import data from git repository (using git_source=<url>)"
  task :import_remote => [:copy_remote_files, :import]

  task :copy_remote_files => :environment do
    fail("No source provided with ENV['git_source']") unless ENV['git_source']
    tmp_path = Rails.root.join('tmp', 'elc-data-git')
    data_path = Rails.root.join('data')

    FileUtils.rm_rf(tmp_path)
    fail("unable to clone repository") unless system :git, "clone #{ENV['git_source']} #{tmp_path}"

    FileUtils.mkdir_p(data_path) unless Dir.exist?(data_path)

    tmp_data_path = File.join(tmp_path, 'data')

    Dir.foreach(tmp_data_path) do |file|
      next if file == '.' or file == '..'

      puts "copying #{file}"

      FileUtils.cp(File.join(tmp_data_path, file), data_path)
    end

    FileUtils.rm_rf(tmp_path)
  end
end