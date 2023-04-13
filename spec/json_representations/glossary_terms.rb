module JsonRepresentations
  module GlossaryTerms

    def glossary_term_representation(glossary_term)
      {
        :long_name => glossary_term.long_name,
        :description => glossary_term.description
      }
    end

  end
end
