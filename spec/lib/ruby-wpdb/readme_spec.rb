require_relative '../../spec_helper'

# Examples from the README; it's obviously important that they work
# since they're people's first exposure to the project!
module WPDB
  describe "README" do
    it "performs more complex queries" do
      post = Post.create(:post_title => 'aaaaa', :post_author => 1)
      post.add_postmeta(:meta_key => 'image', :meta_value => 'test')
      post.save

      meta_value = Post.first(:post_title => /^[a-z]+$/, :ID => post.ID)
        .postmeta_dataset.first(:meta_key => 'image').meta_value
      meta_value.should == 'test'

      post.destroy
    end

    it "creates records" do
      post = Post.create(:post_title => 'Test', :post_content => 'Testing, testing, 123', :post_author => 1)
      post.ID.should be > 0
      post.destroy
    end

    it "creates posts, users, and tags all in one go" do
      author = User.create(
        :user_login => 'fred',
        :user_email => 'fred@example.com'
      )

      term = Term.create(:name => 'Fred Stuff')

      post = Post.create(
        :post_title => 'Hello from Fred',
        :post_content => 'Hello, world',
        :author => author
      )
      post.add_term(term, 'tag')

      author.destroy
      term.destroy
      post.destroy
    end
  end
end
