module WPDB
  class Term < Sequel::Model(:"#{WPDB.prefix}terms")
    plugin :validation_helpers
    plugin :sluggable, :source => :name, :target => :slug

    one_to_many :termtaxonomies, :class => 'WPDB::TermTaxonomy'

    def validate
      super
      validates_presence :name
    end
  end

  class TermTaxonomy < Sequel::Model(:"#{WPDB.prefix}term_taxonomy")
    many_to_one :term, :class => 'WPDB::Term'
    one_to_many :termrelationships, :class => 'WPDB::TermRelationship'
    many_to_many :posts, :left_key => :term_taxonomy_id, :right_key => :object_id, :join_table => :"#{WPDB.prefix}term_relationships", :class => 'WPDB::Post'
    many_to_many :links, :left_key => :term_taxonomy_id, :right_key => :object_id, :join_table => :"#{WPDB.prefix}term_relationships", :class => 'WPDB::Link'
  end

  class TermRelationship < Sequel::Model(:"#{WPDB.prefix}term_relationships")
    def_column_alias(:obj_id, :object_id)

    many_to_one :termtaxonomy, :class => 'WPDB::TermTaxonomy', :key => :term_taxonomy_id
    many_to_one :post, :class => 'WPDB::Post', :key => :object_id
    many_to_one :link, :class => 'WPDB::Link', :key => :object_id
  end

  module Termable
    # For objects that have a relationship with termtaxonomies, this
    # module can be mixed in and gives the ability to add a term
    # directly to the model, rather than creating the relationship
    # yourself. Used by Post and Link.
    def add_term(term, taxonomy)
      if term.respond_to?(:term_id)
        term_id = term.term_id
      else
        term_id = term.to_i
      end

      term_taxonomy = WPDB::TermTaxonomy.where(:term_id => term_id, :taxonomy => taxonomy).first
      unless term_taxonomy
        term_taxonomy = WPDB::TermTaxonomy.create(:term_id => term_id, :taxonomy => taxonomy)
      end

      add_termtaxonomy(term_taxonomy)
    end
  end
end
