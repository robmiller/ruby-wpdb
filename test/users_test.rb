require_relative 'test_helper'

describe WPDB::User do
  before do
    @user = WPDB::User.create(
      :user_login => 'test',
      :user_pass => 'test',
      :user_nicename => 'Testy Testerson',
      :user_email => 'test@example.com',
      :user_registered => DateTime.now
    )
  end

  it "creates a new user" do
    assert @user.ID
  end

  it "adds usermeta" do
    @user.add_usermeta(:meta_key => 'test', :meta_value => 'test')
    @user.save

    user = WPDB::User.where(:ID => @user.ID).first
    meta_value = user.usermeta.first.meta_value
    assert_equal 'test', meta_value
  end

  it "registers the authorship of posts" do
    post = WPDB::Post.create(:post_title => "Testy's first post")
    @user.add_post(post)
    @user.save

    assert_equal "Testy's first post", @user.posts.first.post_title

    assert_equal @user.ID, post.post_author

    post.destroy
  end

  after do
    @user.destroy
  end
end
