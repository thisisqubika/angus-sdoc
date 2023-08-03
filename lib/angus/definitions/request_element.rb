module Angus
  module SDoc
    class Definitions::RequestElement

      # @!attribute [rw] name
      #   @return [String] the name of the request element.
      attr_accessor :name

      # @!attribute [rw] description
      #   @return [String] the description of the request element.
      attr_accessor :description

      # @!attribute [rw] required
      #   @return [Boolean] indicates if the request element is required or not.
      attr_accessor :required

      # @!attribute [rw] type
      #   @return [String] the type of the request element.
      attr_accessor :type

      # @!attribute [rw] constraints
      #   @return [Array<String>] the constraints of the request element.
      attr_accessor :constraints

      # @!attribute [rw] valid_values
      #   @return [Array<String>] the valid values of the request element.
      attr_accessor :valid_values

      # @!attribute [rw] elements_type
      #   @return [String] the elements type of the request element.
      attr_accessor :elements_type

      # @!attribute [rw] optional
      #   @return [Boolean] true if the element is optional
      attr_accessor :optional


      def initialize(name = nil, description = nil, required = nil, type = nil,
                     constraints = nil, valid_values = nil, elements_type = nil, optional = nil)
        self.name = name if name
        self.description = description if description
        self.required = required if required
        self.type = type if type
        self.constraints = constraints if constraints
        self.valid_values = valid_values if valid_values
        self.elements_type = elements_type if elements_type
        self.optional = optional if optional
      end

      # Check if an object is equals to the current instance.
      #
      # @param [RequestElement] other The object to be compared.
      #
      # @return [Boolean] true if all the attributes are equal and false otherwise.
      def == (other)
        other.instance_of?(Definitions::RequestElement) &&
          name == other.name && description == other.description &&
          required == other.required && type == other.type &&
          constraints == other.constraints &&
          valid_values == other.valid_values &&
          elements_type == other.elements_type && optional == other.optional
      end
    end
  end
end
