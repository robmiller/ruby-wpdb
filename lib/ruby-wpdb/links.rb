module WPDB
  class Link < Sequel::Model(:"#{WPDB.prefix}links")
    include Termable

    one_to_many :termrelationships, :key => :object_id, :key_method => :obj_id, :class => 'WPDB::TermRelationship'
    many_to_many :termtaxonomy, :left_key => :object_id, :right_key => :term_taxonomy_id, :join_table => :"#{WPDB.prefix}term_relationships", :class => 'WPDB::TermTaxonomy'
  end
end
