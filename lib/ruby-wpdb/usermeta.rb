module WPDB
  class UserMeta < Sequel::Model(:"#{WPDB.user_prefix}usermeta")
    many_to_one :user, class: "WPDB::User"
  end
end
