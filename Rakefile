require "bundler/gem_tasks"
require 'ci/reporter/rake/minitest'
require 'rake/testtask'

Rake::TestTask.new do |t|
  t.libs = ["lib"]
  t.warning = true
  t.verbose = true
  t.test_files = FileList['test/test_*.rb']
end

task :test => 'ci:setup:minitest'
