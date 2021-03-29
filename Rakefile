# frozen_string_literal: true

require "bundler/gem_tasks"
require "rspec/core/rake_task"
require "reek/rake/task"

RSpec::Core::RakeTask.new(:spec)

require "rubocop/rake_task"

RuboCop::RakeTask.new

Reek::Rake::Task.new do |t|
  t.fail_on_error = true
end

task default: %i[spec rubocop]
