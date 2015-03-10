module WPDB
  class Term < Sequel::Model(:"#{WPDB.prefix}terms")
    plugin :validation_helpers
    plugin :sluggable, source: :name, target: :slug

    one_to_many :termtaxonomies, class: 'WPDB::TermTaxonomy'

    def validate
      super
      validates_presence :name
    end
  end
end
