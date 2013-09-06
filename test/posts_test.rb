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

    meta_value = @post.postmeta.first.meta_value
    assert_equal 'test', meta_value
  end

  it "manages the hierarchy of posts" do
    @post.add_child(WPDB::Post.create(:post_title => 'Child'))
    @post.save

    assert_equal 'Child', @post.children.first.post_title

    @post.children.first.destroy
  end

  it "fetches revisions of posts" do
    revision = WPDB::Post.create(:post_type => 'revision', :post_title => 'Revision', :post_parent => @post.ID)
    assert_equal 'Revision', @post.revisions.first.post_title

    revision.destroy
  end

  it "fetches attachments to posts" do
    attachment = WPDB::Post.create(:post_type => 'attachment', :post_title => 'Attachment', :post_parent => @post.ID)
    assert_equal 'Attachment', @post.attachments.first.post_title

    attachment.destroy
  end

  after do
    @post.destroy
  end
end
