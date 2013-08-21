require_relative 'test_helper'

describe WPDB::Link do
  before do
    @link = WPDB::Link.create(:link_url => 'http://example.com', :link_name => 'Example')
  end

  it "creates links" do
    assert @link.link_id
  end

  it "can attach terms to links" do
    term = WPDB::Term.create(:name => 'terming links')
    @link.add_term(term, 'category')
    @link.save

    assert @link.link_id
    assert @link.termtaxonomy.length
    assert_equal term.term_id, @link.termtaxonomy.first.term_id
    assert_equal 'category', @link.termtaxonomy.first.taxonomy

    term.destroy
  end

  after do
    @link.destroy
  end
end
