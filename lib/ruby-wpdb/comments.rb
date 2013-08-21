Sequel.inflections do |inflect|
  # Unless we tell Sequel otherwise, it will try to inflect the singular
  # of "commentmeta" using the "data" -> "datum" rule, leaving us with the
  # bizarre "commentmetum".
  inflect.uncountable 'commentmeta'
end

module WPDB
  class Comment < Sequel::Model(:"#{WPDB.prefix}comments")
    many_to_one :post, :key => :comment_post_ID, :class => :'WPDB::Post'
    one_to_many :commentmeta, :class => :'WPDB::CommentMeta'
  end

  class CommentMeta < Sequel::Model(:"#{WPDB.prefix}commentmeta")
    many_to_one :comment, :class => :'WPDB::Comment'
  end
end
