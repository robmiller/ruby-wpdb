require_relative '../../spec_helper'

module WPDB
  describe User do
    before do
      @user = User.create(
        user_login: 'test',
        user_pass: 'test',
        user_nicename: 'Testy Testerson',
        user_email: 'test@example.com',
        user_registered: DateTime.now
      )
    end

    it "creates a new user" do
      @user.ID.should be > 0
    end

    it "adds usermeta" do
      @user.add_usermeta(meta_key: 'test', meta_value: 'test')
      @user.save

      user = User.where(ID: @user.ID).first
      meta_value = user.usermeta.first.meta_value
      meta_value.should == 'test'
    end

    it "hashes passwords" do
      @user.save
      @user.user_pass.should == Digest::MD5.hexdigest('test')
    end

    it "registers the authorship of posts" do
      post = Post.create(post_title: "Testy's first post")
      @user.add_post(post)
      @user.reload

      @user.posts.first.post_title.should == "Testy's first post"
      post.post_author.should == @user.ID
    end
  end
end
