module WPDB
  class TermRelationship < Sequel::Model(:"#{WPDB.prefix}term_relationships")
    def_column_alias(:obj_id, :object_id)

    many_to_one :post, class: 'WPDB::Post', key: :object_id
    many_to_one :link, class: 'WPDB::Link', key: :object_id
    
    many_to_one :termtaxonomy,
      class: 'WPDB::TermTaxonomy',
      key: :term_taxonomy_id
  end
end
