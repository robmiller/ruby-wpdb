module WPDB
  class PostMeta < Sequel::Model(:"#{WPDB.prefix}postmeta")
    many_to_one :post, class: 'WPDB::Post'
  end
end
