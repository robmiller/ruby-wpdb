Sequel.inflections do |inflect|
  # Unless we tell Sequel otherwise, it will try to inflect the singular
  # of "commentmeta" using the "data" -> "datum" rule, leaving us with the
  # bizarre "commentmetum".
  inflect.uncountable 'commentmeta'
end

module WPDB
  class Comment < Sequel::Model(:"#{WPDB.prefix}comments")
    plugin :validation_helpers

    many_to_one :post, key: :comment_post_ID, class: 'WPDB::Post'
    one_to_many :commentmeta, class: 'WPDB::CommentMeta'

    def validate
      super
      validates_presence [:comment_author, :comment_author_email, :comment_date, :comment_date_gmt, :comment_parent, :comment_approved]
    end

    def before_validation
      self.comment_date     ||= Time.now
      self.comment_date_gmt ||= Time.now.utc
      self.comment_parent   ||= 0
      self.comment_approved ||= 1
      super
    end
  end
end
