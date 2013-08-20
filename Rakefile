require 'rake/testtask'

task :default => [:'']

desc "Run all tests"
task :'' do
  Rake::TestTask.new("alltests") do |t|
    t.test_files = Dir.glob(File.join("test", "**", "*_test.rb"))
  end
  task("alltests").execute
end
