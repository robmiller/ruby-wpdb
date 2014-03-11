$:.push File.expand_path("../lib", __FILE__)
require "ruby-wpdb/version"

Gem::Specification.new do |s|
  s.name = "ruby-wpdb"
  s.version = WPDB::VERSION
  s.date = "2013-10-24"

  s.summary = "A Ruby ORM wrapper for WordPress"
  s.description = "ruby-wpdb gives you a painless way to access and interact with WordPress from Ruby, accessing posts, tags, and all other WordPress concepts as plain-old Ruby objects."

  s.authors = ["Rob Miller"]
  s.email = "rob@bigfish.co.uk"
  s.homepage = "http://github.com/robmiller/ruby-wpdb"

  s.license = "MIT"

  s.files = Dir.glob("{bin,lib,data,test}/**/*") + %w(LICENSE README.md Gemfile)
  s.require_path = 'lib'
  s.executables = ['ruby-wpdb']

  s.add_runtime_dependency 'mysql2', '~> 0.3.11'
  s.add_runtime_dependency 'sequel', '~> 4.2.0'
  s.add_runtime_dependency 'sequel_sluggable', '~> 0.0.6'
  s.add_runtime_dependency 'php-serialize', '~> 1.1'
  s.add_runtime_dependency 'pry', '~> 0.9.12'
  s.add_runtime_dependency 'thor', '~> 0.18.1'

  s.add_development_dependency 'rake', '~> 10.1.0'
  s.add_development_dependency 'letters', '~> 0.4.1'
end
