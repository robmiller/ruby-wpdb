$:.unshift File.expand_path('../lib', File.dirname(__FILE__))
require 'bundler/setup'

require 'yaml'

require 'sequel'

require 'simplecov'
SimpleCov.start

require 'ruby-wpdb'

WPDB.from_config

RSpec.configure do |c|
  c.around(:each) do |example|
    WPDB.db.transaction(rollback: :always){ example.run }
  end
end

require 'logger'
WPDB.db.logger = Logger.new('data/query.log')

