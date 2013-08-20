require 'bundler'
Bundler.setup

require 'yaml'
require 'letters'

require 'sequel'

require 'ruby-wpdb'

WPDB.from_config

require 'minitest/autorun'
