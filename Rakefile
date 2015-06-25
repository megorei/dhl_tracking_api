require 'rspec/core/rake_task'
require "bundler/gem_tasks"

RSpec::Core::RakeTask.new(:spec) do |task|
  task.rspec_opts = ['--color']
  # task.rspec_opts = ['--format', 'documentation']
  task.rspec_opts = ['--format', 'progress']
end

task :default => :spec


