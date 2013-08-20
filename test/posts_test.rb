require_relative 'test_helper'

describe WPDB::Post do
  before do
    @post = WPDB::Post.create(:post_title => 'Hello world')
  end

  it "creates a new post" do
    assert @post.ID
  end

  it "fetches all posts" do
    assert WPDB::Post.all
  end

  it "manages postmeta" do
    @post.add_postmeta(:meta_key => 'test', :meta_value => 'test')
    @post.save

    post = WPDB::Post.where(:ID => @post.ID).first
    meta_value = post.postmeta.first.meta_value
    assert_equal 'test', meta_value
  end

  it "manages the hierarchy of posts" do
    parent = WPDB::Post.create(:post_title => 'Parent')
    parent.add_child(WPDB::Post.create(:post_title => 'Child'))
    parent.save

    parent = WPDB::Post.find(:ID => parent.ID)
    assert parent.children.first.post_title = 'Child'
  end
end
