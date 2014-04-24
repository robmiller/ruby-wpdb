require_relative '../../spec_helper'

module WPDB
  describe Link do
    before do
      @link = Link.create(:link_url => 'http://example.com', :link_name => 'Example')
    end

    it "creates links" do
      @link.link_id.should be > 0
    end

    it "can attach terms to links" do
      term = Term.create(:name => 'terming links')
      @link.add_term(term, 'category')
      @link.save

      @link.link_id.should be > 0
      @link.termtaxonomy.should_not be_empty
      @link.termtaxonomy.first.term_id.should == term.term_id
      @link.termtaxonomy.first.taxonomy.should == 'category'

      term.destroy
    end

    after do
      @link.destroy
    end
  end
end
