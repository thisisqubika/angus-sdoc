module Picasso
  module SDoc

    class Definitions::RepresentationField
      attr_accessor :name
      attr_accessor :description
      attr_accessor :required
      attr_accessor :type
      attr_accessor :elements_type

      def initialize(name = nil, description = nil, required = nil, type = nil, elements_type = nil)
        self.name= name
        self.description= description
        self.required= required
        self.type= type
        self.elements_type= elements_type
      end

      def == (other)
        other.kind_of?(Definitions::RepresentationField) &&
          self.name == other.name && self.description == other.description &&
          self.required == other.required && self.type == other.type && self.elements_type == other.elements_type
      end
    end

  end
end