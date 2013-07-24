module Picasso
  module SDoc
    class Definitions::GlossaryTerm < Struct.new(:short_name, :long_name, :description)

      class << self

        # Initialize multiple GlossaryTerm using the information on the hash parameter.
        #
        # @param [Hash<String, Hash<String, String>] hash this Hash contains GlossaryTerm#short_name
        #   as key and other Hash with the other attributes of the GlossaryTerm as a value.
        #
        # @return Array<GlossaryTerm>
        def build_from_hash(hash = {})
          hash.map do |sort_name, gt|
            self.new(sort_name, gt['long_name'], gt['description'])
          end
        end

      end

      # Check if other is equals to the current instance.
      #
      # @return Boolean true if are equals and false otherwise.
      def == (other)
        other.kind_of?(Definitions::GlossaryTerm) &&
          self.short_name == other.short_name && self.long_name == other.long_name &&
          self.description == other.description
      end

    end
  end
end