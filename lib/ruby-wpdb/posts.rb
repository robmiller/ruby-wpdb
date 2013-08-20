Sequel.inflections do |inflect|
  # Unless we tell Sequel otherwise, it will try to inflect the singular
  # of "postmeta" using the "data" -> "datum" rule, leaving us with the
  # bizarre "postmetum".
  inflect.uncountable 'postmeta'
end

module WPDB
  class Post < Sequel::Model(:"#{WPDB.prefix}posts")
    one_to_many :children, :key => :post_parent, :class => self

    one_to_many :postmeta, :class => :'WPDB::PostMeta'
  end

  class PostMeta < Sequel::Model(:"#{WPDB.prefix}postmeta")
  end
end
