require_relative 'representation_fields'

module JsonRepresentations
  module Representations
    include RepresentationFields

    def representation_representation(representation)
      representation.fields.map { |field| representation_field_representation(field) }
    end

  end
end
