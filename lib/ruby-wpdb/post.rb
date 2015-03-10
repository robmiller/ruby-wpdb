Sequel.inflections do |inflect|
  # Unless we tell Sequel otherwise, it will try to inflect the singular
  # of "postmeta" using the "data" -> "datum" rule, leaving us with the
  # bizarre "postmetum".
  inflect.uncountable 'postmeta'
end

module WPDB
  class Post < Sequel::Model(:"#{WPDB.prefix}posts")
    include Termable

    plugin :validation_helpers
    plugin :sluggable, source: :post_title, target: :post_name

    one_to_many :children,
      key: :post_parent,
      class: self do |ds|
        ds.where(post_type: ['attachment', 'revision']).invert
          .where(post_parent: self.ID)
      end
    one_to_many :revisions,
      key: :post_parent,
      class: self,
      conditions: { post_type: 'revision' }

    one_to_many :attachments,
      key: :post_parent,
      class: self,
      conditions: { post_type: 'attachment' }

    # In order to use Sequel add_postmeta function.
    one_to_many :postmeta, class: 'WPDB::PostMeta'
    one_to_many :comments, key: :comment_post_ID, class: 'WPDB::Comment'
    one_to_many :termrelationships,
      key: :object_id,
      key_method: :obj_id,
      class: 'WPDB::TermRelationship'

    many_to_one :parent, class: self, key: :post_parent
    many_to_one :author, key: :post_author, class: 'WPDB::User'

    many_to_many :termtaxonomy,
      left_key: :object_id,
      right_key:  :term_taxonomy_id,
      join_table: "#{WPDB.prefix}term_relationships",
      class: 'WPDB::TermTaxonomy'

    def validate
      super
      validates_presence [:post_title, :post_type, :post_status]
      validates_unique :post_name
    end

    def before_validation
      self.post_type      ||= "post"
      self.post_status    ||= "draft"
      self.post_parent    ||= 0
      self.menu_order     ||= 0
      self.comment_status ||= "open"
      self.ping_status    ||= WPDB::Option.get_option("default_ping_status")
      self.post_date      ||= Time.now
      self.post_date_gmt  ||= Time.now.utc
      super
    end
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

      term_taxonomy = WPDB::TermTaxonomy.where(term_id: term_id, taxonomy: taxonomy).first
      unless term_taxonomy
        term_taxonomy = WPDB::TermTaxonomy.create(term_id: term_id, taxonomy: taxonomy)
      end

      add_termtaxonomy(term_taxonomy)
    end
  end
end
