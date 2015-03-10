module WPDB
  class Option < Sequel::Model(:"#{WPDB.prefix}options")
    plugin :validation_helpers

    def validate
      super
      validates_presence [:option_name]
    end

    def before_validation
      self.autoload ||= "yes"
      super
    end

    # Given the name of an option, will return the option value for that
    # option - or nil of no option with that name exists.
    #
    # @param [String] name The option_name to fetch
    # @return String
    def self.get_option(name)
      Option.where(option_name: name).get(:option_value)
    end
  end
end
