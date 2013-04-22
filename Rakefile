require './lib/tinyseabots/web'
require 'rake/testtask'

task :default => :test

Rake::TestTask.new do |t|
  t.libs << 'test'
  t.test_files = FileList['test/*/*_test.rb']
end

namespace :db do
  namespace :migrate do
    MIGRATION_DIRECTORY = 'migration'
    Sequel.extension :migration, :core_extensions
    task :up do
      Sequel::Migrator.apply(Tinyseabots::Web::Model::DB, MIGRATION_DIRECTORY) 
    end

    task :down do
      schema_info= Tinyseabots::Web::Model::DB[:schema_info].first
      version = (schema_info.nil?) ? nil : schema_info[:version]

      Sequel::Migrator.apply(Tinyseabots::Web::Model::DB,
        MIGRATION_DIRECTORY,
        version - 1) 
    end

    task :reset do
      Sequel::Migrator.apply(Tinyseabots::Web::Model::DB, MIGRATION_DIRECTORY, 0)
    end
  end

end
