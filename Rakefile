require "bundler/gem_tasks"
require 'reek/rake/task'
require 'rubocop/rake_task'

task :default => :spec

Reek::Rake::Task.new do |t|
  t.fail_on_error = false
end

RuboCop::RakeTask.new
