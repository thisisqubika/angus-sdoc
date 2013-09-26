require_relative 'glossary_terms'

module JsonRepresentations
  module Glossaries
    include GlossaryTerms

    def glossary_representation(glossary)
      glossary.terms.inject({}) do |result, term|
        result.merge({ term.short_name => glossary_term_representation(term) })
      end
    end

  end
end