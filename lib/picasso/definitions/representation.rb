module Picasso
  module SDoc
    class Definitions::Representation

      # @!attribute [rw] name
      #   @return [String] the name of the representation.
      attr_accessor :name

      # @!attribute [rw] fields
      #   @return [Array<RepresentationField>] the fields of the representation.
      attr_accessor :fields

    end
  end
end