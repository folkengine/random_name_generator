require 'bundler/gem_tasks'
require 'rake/testtask'
require 'reek/rake/task'
require 'rubocop/rake_task'

task default: :test

Reek::Rake::Task.new do |t|
  t.fail_on_error = false
end

RuboCop::RakeTask.new

Rake::TestTask.new do |t|
  t.libs << 'test'
  t.test_files = FileList['test/**/test*.rb']
  t.verbose = true
end

task :boom do
  Rake::Task['test'].execute
  puts 'Running Reek...'
  Rake::Task['reek'].execute
  puts
  Rake::Task['rubocop'].execute
end
