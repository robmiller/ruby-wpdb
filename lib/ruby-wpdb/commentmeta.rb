module WPDB
  class CommentMeta < Sequel::Model(:"#{WPDB.prefix}commentmeta")
    many_to_one :comment, class: :'WPDB::Comment'
  end
end
