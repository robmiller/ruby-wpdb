require 'bundler'
Bundler.setup

require 'sequel'

module WPDB
  class << self
    attr_accessor :prefix, :user_prefix

    # Given the path to a YAML file, will initialise WPDB using the
    # config files found in that file.
    def from_config(file = nil)
      file ||= File.dirname(__FILE__) + '/../config.yml'
      config = YAML::load_file(file)

      uri  = 'mysql2://'
      uri += "#{config['username']}:#{config['password']}"
      uri += "@#{config['hostname']}"
      uri += ":#{config['port']}" if config['port']
      uri += "/#{config['database']}"

      init(uri, config['prefix'])
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
      Sequel.connect(uri)
      WPDB.prefix = prefix || 'wp_'
      WPDB.user_prefix = user_prefix || WPDB.prefix

      require_relative 'ruby-wpdb/posts'
      require_relative 'ruby-wpdb/users'
      require_relative 'ruby-wpdb/options'
      require_relative 'ruby-wpdb/comments'
      require_relative 'ruby-wpdb/terms'
    end
  end
end

