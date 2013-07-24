module Picasso
  module SDoc

    class Definitions::Glossary

      attr_accessor :terms

      # Initializes a new Glossary and it's terms.
      #
      # @param [Hash<String, Hash<String, String>] terms_hash this Hash contains GlossaryTerm#short_name
      #   as key and other Hash with the other attributes of the GlossaryTerm as a value.
      #
      # @example
      #
      #   {'Glossary Term Name' =>
      #     {
      #       'long_name'   => 'Long name of the glossary term',
      #       'description' => 'Description of the glossary term'
      #     }
      #   }
      def initialize(terms_hash = {})
        @terms = Picasso::SDoc::Definitions::GlossaryTerm.build_from_hash(terms_hash)
      end

      # Returns a hash with short name as key and the term as the value.
      #
      # @return Hash<String, GlossaryTerm>
      def terms_hash
        hash = {}

        @terms.each do |term|
          hash[term.short_name] = term
        end

        hash
      end

      # Returns a hash with long name as key and the term as the value.
      #
      # @return Hash<String, GlossaryTerm>
      def terms_hash_with_long_names
        hash = {}
        @terms.each do |term|
          hash[term.long_name] = term
        end
        hash
      end
    end

  end
end