require_relative 'test_helper'

describe WPDB::Term do
  before do
    @term = WPDB::Term.create(:name => 'test')
    @term_taxonomy = WPDB::TermTaxonomy.create(:term_id => @term.term_id, :taxonomy => 'category')
  end

  it "saves terms" do
    assert @term.term_id
  end

  it "attaches terms to posts" do
    post = WPDB::Post.create(:post_title => 'test', :post_author => 1)
    post.add_termtaxonomy(@term_taxonomy)
    post.save

    assert post.ID
    assert post.termtaxonomy.length
    assert_equal @term.term_id, post.termtaxonomy.first.term_id
    assert_equal 'category', post.termtaxonomy.first.taxonomy

    post.destroy
  end

  it "attaches terms to posts with the shorthand" do
    post = WPDB::Post.create(:post_title => 'test', :post_author => 1)
    post.add_term(@term, 'category')
    post.save

    assert post.ID
    assert post.termtaxonomy.length
    assert_equal @term.term_id, post.termtaxonomy.first.term_id
    assert_equal 'category', post.termtaxonomy.first.taxonomy

    post.destroy
  end

  after do
    @term.destroy
  end
end
