require_relative '../../spec_helper'

module WPDB
  describe Post do
    before do
      @post = Post.create(:post_title => 'Hello world', :post_author => 1)
    end

    it "creates a new post" do
      @post.ID.should be > 0
    end

    it "fetches all posts" do
      Post.all.should_not be_empty
    end

    it "manages postmeta" do
      @post.add_postmeta(:meta_key => 'test', :meta_value => 'test')
      @post.save

      meta_value = @post.postmeta.first.meta_value
      meta_value.should == 'test'
    end

    it "manages the hierarchy of posts" do
      @post.add_child(Post.create(:post_title => 'Child', :post_author => 1))
      @post.save

      @post.children.first.post_title.should == 'Child'

      @post.children.first.destroy
    end

    it "fetches revisions of posts" do
      revision = Post.create(:post_type => 'revision', :post_title => 'Revision', :post_parent => @post.ID, :post_author => 1)
      @post.revisions.first.post_title.should == 'Revision'

      revision.destroy
    end

    it "fetches attachments to posts" do
      attachment = Post.create(:post_type => 'attachment', :post_title => 'Attachment', :post_parent => @post.ID, :post_author => 1)
      @post.attachments.first.post_title.should == 'Attachment'

      attachment.destroy
    end

    after do
      @post.destroy
    end
  end
end
