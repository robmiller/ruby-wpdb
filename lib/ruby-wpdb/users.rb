Sequel.inflections do |inflect|
  # Unless we tell Sequel otherwise, it will try to inflect the singular
  # of "usermeta" using the "data" -> "datum" rule, leaving us with the
  # bizarre "usermetum".
  inflect.uncountable 'usermeta'
end

module WPDB
  class User < Sequel::Model(:"#{WPDB.user_prefix}users")
    one_to_many :usermeta, :class => :'WPDB::UserMeta'
    one_to_many :posts, :key => :post_author, :class => :'WPDB::Post'
  end

  class UserMeta < Sequel::Model(:"#{WPDB.user_prefix}usermeta")
  end
end
