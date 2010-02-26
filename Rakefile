# Add your own tasks in files placed in lib/tasks ending in .rake,
# for example lib/tasks/capistrano.rake, and they will automatically be available to Rake.

require(File.join(File.dirname(__FILE__), 'config', 'boot'))

require 'rake'
require 'rake/testtask'
require 'rake/rdoctask'

require 'tasks/rails'

task :default => [:runcoderun]

  desc 'Run the rspec and cucumber tests for runcoderun'
  task :runcoderun do
    # Make sure everything is run using the test environment
    RAILS_ENV = ENV['RAILS_ENV'] = 'test'

    # Run rspec tests
    Rake::Task['spec'].invoke

    # Cucumber needs CMSAdmin user to log in and test so set up the db
    # The user is set up in a migration
    Rake::Task['db:migrate:reset'].invoke
    Rake::Task['cucumber:ok'].invoke
  end
