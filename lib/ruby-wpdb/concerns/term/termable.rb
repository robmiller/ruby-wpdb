module Term::Termable
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
