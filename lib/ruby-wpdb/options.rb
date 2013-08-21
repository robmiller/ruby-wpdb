module WPDB
  class Option < Sequel::Model(:"#{WPDB.prefix}options")
  end
end
