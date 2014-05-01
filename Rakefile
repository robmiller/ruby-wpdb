require "rspec/core/rake_task"

task :default => [:spec]

desc "Run all specs"
RSpec::Core::RakeTask.new do |t|
  t.pattern = "spec/**/*_spec.rb"
  t.rspec_opts = "-b"
end

desc "Run mutation tests"
task :mutant do
  system "mutant --fail-fast --include lib --require ruby-wpdb --use rspec '::WPDB*'"
end
