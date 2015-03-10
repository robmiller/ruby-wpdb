require_relative '../../spec_helper'

module WPDB
  describe Comment do
    before do
      @comment = Comment.create(
        comment_author: 'Testy Testerson',
        comment_author_email: 'testy@example.com',
        comment_content: 'Test'
      )
    end

    it "creates a new comment" do
      @comment.comment_ID.should be > 0
    end

    it "attaches comments to posts" do
      post = Post.create(post_title: 'test', post_author: 1)
      post.ID.should be > 0

      post.add_comment(@comment)
      @comment.post.should be
      post.comments.should_not be_empty
      post.ID.should == post.comments.first.comment_post_ID

      post.destroy
    end

    it "adds commentmeta" do
      @comment.add_commentmeta(meta_key: 'test', meta_value: 'test')

      comment = Comment.where(comment_ID: @comment.comment_ID).first
      comment.commentmeta.should_not be_empty
      comment.commentmeta.first.meta_key.should == 'test'
      comment.commentmeta.first.meta_value.should == 'test'
    end

    after do
      @comment.destroy
    end
  end
end
