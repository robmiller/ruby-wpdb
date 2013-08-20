module WPDB
  class Term < Sequel::Model(:"#{WPDB.prefix}terms")
    one_to_many :termtaxonomies, :class => 'WPDB::TermTaxonomy'
  end

  class TermTaxonomy < Sequel::Model(:"#{WPDB.prefix}term_taxonomy")
    many_to_one :terms, :class => 'WPDB::Term'
    one_to_many :termrelationships, :class => 'WPDB::TermRelationship'
    many_to_many :posts, :left_key => :term_taxonomy_id, :right_key => :object_id, :join_table => :"#{WPDB.prefix}term_relationships", :class => 'WPDB::Post'
  end

  class TermRelationship < Sequel::Model(:"#{WPDB.prefix}term_relationships")
    def_column_alias(:obj_id, :object_id)

    many_to_one :termtaxonomy, :class => 'WPDB::TermTaxonomy'
    many_to_one :posts, :class => 'WPDB::Post'
  end
end
