module WPDB
  class Option < Sequel::Model(:"#{WPDB.prefix}options")
    # Given the name of an option, will return the option value for that
    # option - or nil of no option with that name exists.
    #
    # @param [String] name The option_name to fetch
    # @return String
    def self.get_option(name)
      Option.where(:option_name => name).get(:option_value)
    end
  end
end
