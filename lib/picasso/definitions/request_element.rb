module Picasso
  module SDoc
    class Definitions::RequestElement

      attr_accessor :name
      attr_accessor :description
      attr_accessor :required
      attr_accessor :type
      attr_accessor :constraints
      attr_accessor :valid_values
      attr_accessor :elements_type

      def initialize(name = nil, description = nil, required = nil, type = nil,
                     constraints = nil, valid_values = nil, elements_type = nil)
        self.name= name if name
        self.description= description if description
        self.required= required if required
        self.type= type if type
        self.constraints= constraints if constraints
        self.valid_values= valid_values if valid_values
        self.elements_type= elements_type if elements_type
      end

      def == (other)
        other.instance_of?(Definitions::RequestElement) &&
          self.name == other.name && self.description == other.description &&
          self.required == other.required && self.type == other.type &&
          self.constraints == other.constraints &&
          self.valid_values == other.valid_values &&
          self.elements_type == other.elements_type
      end

    end
  end
end