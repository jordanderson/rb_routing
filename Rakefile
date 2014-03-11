require "bundler/gem_tasks"
require 'rspec/core/rake_task'

desc "Print RbRouting version"
task :version do
  puts RbRouting::VERSION
end

desc "Check syntax of all .rb files"
task :check_syntax do
  Dir['**/*.rb'].each{|file| print `#{FileUtils::RUBY} -c #{file} | fgrep -v "Syntax OK"`}
end

RSpec::Core::RakeTask.new(:spec)

task :default => :spec