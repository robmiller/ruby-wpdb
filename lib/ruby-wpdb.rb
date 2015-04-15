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
      config_file = config_file(file)

      init(config_file.config[:uri], config_file.config[:prefix])
    end

    def config_file(file = nil)
      file = Config::AutoDiscover.new.file unless file
      raise ConfigFileError, "No config file specified, and none found" unless file

      file = Config::AutoFormat.new(file)
      raise ConfigFileError, "Unknown config file format for file #{file}" unless file.format

      file
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

      require_relative 'ruby-wpdb/option'
      require_relative 'ruby-wpdb/user'
      require_relative 'ruby-wpdb/usermeta'
      require_relative 'ruby-wpdb/term'
      require_relative 'ruby-wpdb/term_relationship'
      require_relative 'ruby-wpdb/term_taxonomy'
      require_relative 'ruby-wpdb/post'
      require_relative 'ruby-wpdb/postmeta'
      require_relative 'ruby-wpdb/comment'
      require_relative 'ruby-wpdb/commentmeta'
      require_relative 'ruby-wpdb/link'
      require_relative 'ruby-wpdb/gravityforms'

      WPDB.initialized = true
    end
  end
end
