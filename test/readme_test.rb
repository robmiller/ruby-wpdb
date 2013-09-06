require_relative 'test_helper'

# Examples from the README; it's obviously important that they work
# since they're people's first exposure to the project!
describe "README" do
  it "performs more complex queries" do
    post = WPDB::Post.create(:post_title => 'aaaaa')
    post.add_postmeta(:meta_key => 'image', :meta_value => 'test')
    post.save

    meta_value = WPDB::Post.first(:post_title => /^[a-z]+$/, :ID => post.ID)
      .postmeta_dataset.first(:meta_key => 'image').meta_value
    assert_equal 'test', meta_value

    post.destroy
  end

  it "creates records" do
    post = WPDB::Post.create(:post_title => 'Test', :post_content => 'Testing, testing, 123')
    assert post.ID
    post.destroy
  end

  it "creates posts, users, and tags all in one go" do
    author = WPDB::User.create(
      :user_login => 'fred',
      :user_email => 'fred@example.com'
    )

    term = WPDB::Term.create(:name => 'Fred Stuff', :slug => 'fred-stuff')

    post = WPDB::Post.create(
      :post_title => 'Hello from Fred',
      :post_content => 'Hello, world',
      :author => author
    ).add_term(term, 'tag')

    author.destroy
    post.destroy
    term.destroy
  end
end
