require_relative '../../spec_helper'

module WPDB
  describe Term do
    before do
      @term = Term.create(name: 'test')
      @term_taxonomy = TermTaxonomy.create(term_id: @term.term_id, taxonomy: 'category')
    end

    it "saves terms" do
      @term.term_id.should be > 0
    end

    it "attaches terms to posts" do
      post = Post.create(post_title: 'test', post_author: 1)
      post.add_termtaxonomy(@term_taxonomy)
      post.save

      post.ID.should be > 0
      post.termtaxonomy.length.should be > 0
      post.termtaxonomy.first.term_id.should == @term.term_id
      post.termtaxonomy.first.taxonomy.should == 'category'
    end

    it "attaches terms to posts with the shorthand" do
      post = Post.create(post_title: 'test', post_author: 1)
      post.add_term(@term, 'category')
      post.save

      post.ID.should be > 0
      post.termtaxonomy.length.should be > 0
      post.termtaxonomy.first.term_id.should == @term.term_id
      post.termtaxonomy.first.taxonomy.should == 'category'
    end

    it "attaches terms to posts by ID" do
      post = Post.create(post_title: 'test', post_author: 1)
      post.add_term(@term.term_id, 'category')
      post.save

      post.ID.should be > 0
      post.termtaxonomy.length.should be > 0
      post.termtaxonomy.first.term_id.should == @term.term_id
      post.termtaxonomy.first.taxonomy.should == 'category'
    end
  end
end
