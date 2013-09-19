module Picasso
  module SDoc
    # @attr [String] short_name The short name of the glossary term.
    # @attr [String] long_name The long name of the glossary term.
    # @attr [String] description The description of the glossary term.
    class Definitions::GlossaryTerm < Struct.new(:short_name, :long_name, :description)

      class << self

        # Initialize multiple GlossaryTerm using the information in the hash parameter.
        #
        # @param [Hash] hash The Hash contains GlossaryTerm#short_name
        #   as key and other Hash with the other attributes of the GlossaryTerm as a value.
        #
        # @return [Array<GlossaryTerm>] The list of glossary terms.
        def build_from_hash(hash = {})
          hash.map do |sort_name, gt|
            self.new(sort_name, gt['long_name'], gt['description'])
          end
        end

      end

      # Check if an object is equals to the current instance.
      #
      # @param [GlossaryTerm] other The object to be compared.
      #
      # @return [Boolean] true if all the attributes are equal and false otherwise.
      def == (other)
        other.kind_of?(Definitions::GlossaryTerm) &&
          self.short_name == other.short_name && self.long_name == other.long_name &&
          self.description == other.description
      end

    end
  end
end