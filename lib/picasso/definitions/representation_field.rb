module Picasso
  module SDoc

    class Definitions::Glossary
      # Array<GlossaryTerm>
      attr_accessor :terms

      def initialize
        @terms = []
      end

      def terms_hash
        hash = {}
        @terms.each do |term|
          hash[term.short_name] = term
        end
        hash
      end

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