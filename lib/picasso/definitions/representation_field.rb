module Picasso
  module SDoc
    class Definitions::RepresentationField

      # @!attribute [rw] name
      #   @return [String] the name of the representation field.
      attr_accessor :name

      # @!attribute [rw] description
      #   @return [String] the description of the representation field.
      attr_accessor :description

      # @!attribute [rw] required
      #   @return [Boolean] indicates if the representation field is required or not.
      attr_accessor :required

      # @!attribute [rw] type
      #   @return [String] the type of the representation field.
      #     This attribute is used when the representation is a single object.
      attr_accessor :type

      # @!attribute [rw] elements_type
      #   @return [String] the elements type of the representation field.
      #     This attribute is used when the representation is a list of objects.
      attr_accessor :elements_type

      # @note if the elements_type attribute is different from nil, it means that the
      #   representation field is a list of objects. In that case, the type parameter
      #   is not considered.
      def initialize(name = nil, description = nil, required = nil, type = nil, elements_type = nil)
        self.name= name
        self.description= description
        self.required= required
        self.type= type
        self.elements_type= elements_type
      end

      # Check if an object is equals to the current instance.
      #
      # @param [RepresentationField] other The object to be compared.
      #
      # @return [Boolean] true if all the attributes are equal and false otherwise.
      def == (other)
        other.kind_of?(Definitions::RepresentationField) &&
          self.name == other.name && self.description == other.description &&
          self.required == other.required && self.type == other.type && self.elements_type == other.elements_type
      end

    end
  end
end