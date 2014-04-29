require 'bundler/setup'

require 'sequel'
require 'pry'
require 'pathname'

require_relative 'ruby-wpdb/config'

module WPDB
  class ConfigFileError < StandardError; end

  class << self
    attr_accessor :db, :prefix, :user_prefix, :initialized

    # Given the path to a YAML file, will initialise WPDB using the
    # config files found in that file.
    def from_config(file = nil)
      file ||= File.dirname(__FILE__) + '/../config.yml'
      config_file = config_file(file)

      init(config_file.config[:uri], config_file.config[:prefix])
    end

    def config_file(file)
      file = Pathname(file)
      case file.extname
      when ".yml", ".yaml"
        config_file = Config::YAML.new(file)
      when ".php"
        config_file = Config::WPConfig.new(file)
      else
        raise ConfigFileError, "Unknown config file format"
      end
    end

    # Initialises Sequel, sets up some necessary variables (like
    # WordPress's table prefix), and then includes our models.
    #
    # @param [String] A database connection uri, e.g.
    #   mysql2://user:pass@host:port/dbname
    # @param [String] The database table prefix used by the install of
    #   WordPress you'll be querying. Defaults to wp_
    # @param [String] The prefix of the users table; if not specified,
    #   the general database table prefix will be used.
    def init(uri, prefix = nil, user_prefix = nil)
      WPDB.db          = Sequel.connect(uri)
      WPDB.prefix      = prefix || 'wp_'
      WPDB.user_prefix = user_prefix || WPDB.prefix

      require_relative 'ruby-wpdb/options'
      require_relative 'ruby-wpdb/users'
      require_relative 'ruby-wpdb/terms'
      require_relative 'ruby-wpdb/posts'
      require_relative 'ruby-wpdb/comments'
      require_relative 'ruby-wpdb/links'
      require_relative 'ruby-wpdb/gravityforms'

      WPDB.initialized = true
    end
  end
end

