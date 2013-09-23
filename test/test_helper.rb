$:.unshift File.expand_path('../lib', File.dirname(__FILE__))
require 'bundler'
Bundler.setup

require 'yaml'
require 'letters'

require 'sequel'

require 'ruby-wpdb'

WPDB.from_config

require 'logger'
WPDB.db.logger = Logger.new($stdout)

require 'minitest/autorun'
