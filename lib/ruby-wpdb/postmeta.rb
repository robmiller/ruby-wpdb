module WPDB
  class PostMeta < Sequel::Model(:"#{WPDB.prefix}postmeta")
    # Many postmeta belongs to ONE post, not to more tha one post
    many_to_one :post, class: 'WPDB::Post'
  end
end
