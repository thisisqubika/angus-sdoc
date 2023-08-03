module Angus
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

      # @!attribute [rw] optional
      #   @return [Boolean] true if the element is optional
      attr_accessor :optional

      # @note if the elements_type attribute is different from nil, it means that the
      #   representation field is a list of objects. In that case, the type parameter
      #   is not considered.
      def initialize(name = nil, description = nil, required = nil, type = nil, elements_type = nil,
                     optional = nil)
        self.name = name
        self.description = description
        self.required = required
        self.type = type
        self.elements_type = elements_type
        self.optional = optional
      end

      # Check if an object is equals to the current instance.
      #
      # @param [RepresentationField] other The object to be compared.
      #
      # @return [Boolean] true if all the attributes are equal and false otherwise.
      def ==(other)
        other.kind_of?(Definitions::RepresentationField) &&
          name == other.name && description == other.description &&
          required == other.required && type == other.type &&
          elements_type == other.elements_type && optional == other.optional
      end
    end
  end
end
