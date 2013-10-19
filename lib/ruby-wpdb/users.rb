require 'digest/md5'

Sequel.inflections do |inflect|
  # Unless we tell Sequel otherwise, it will try to inflect the singular
  # of "usermeta" using the "data" -> "datum" rule, leaving us with the
  # bizarre "usermetum".
  inflect.uncountable 'usermeta'
end

module WPDB
  class User < Sequel::Model(:"#{WPDB.user_prefix}users")
    plugin :validation_helpers

    one_to_many :usermeta, :class => :'WPDB::UserMeta'
    one_to_many :posts, :key => :post_author, :class => :'WPDB::Post'

    def validate
      super
      validates_presence [:user_login, :user_pass, :user_email, :user_registered]
      validates_unique :user_login, :user_email
    end

    def before_validation
      self.user_registered ||= Time.now

      # If the password we've been given isn't a hash, then MD5 it.
      # Although WordPress no longer uses MD5 hashes, it will update
      # them on successful login, so we're ok to create them here.
      unless user_pass =~ /\$[A-Z]\$/ || user_pass =~ /[a-z0-9]{32}/
        self.user_pass = Digest::MD5.hexdigest(user_pass.to_s)
      end

      super
    end
  end

  class UserMeta < Sequel::Model(:"#{WPDB.user_prefix}usermeta")
  end
end
