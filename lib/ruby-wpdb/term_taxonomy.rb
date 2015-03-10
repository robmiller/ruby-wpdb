module WPDB
  class TermTaxonomy < Sequel::Model(:"#{WPDB.prefix}term_taxonomy")
    one_to_many :termrelationships, class: 'WPDB::TermRelationship'

    many_to_one :term, class: 'WPDB::Term'

    many_to_many :posts,
      left_key: :term_taxonomy_id,
      right_key: :object_id,
      join_table: "#{WPDB.prefix}term_relationships",
      class: 'WPDB::Post'

    many_to_many :links,
      left_key: :term_taxonomy_id,
      right_key: :object_id,
      join_table: "#{WPDB.prefix}term_relationships",
      class: 'WPDB::Link'
  end
end
