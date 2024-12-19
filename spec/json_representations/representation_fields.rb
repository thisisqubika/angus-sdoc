module JsonRepresentations
  module RepresentationFields

    def representation_field_representation(representation_field)
      representation = {
        field: representation_field.name,
        description: representation_field.description,
        required: representation_field.required,
        optional: representation_field.optional
      }

      representation.merge!({ type: representation_field.type }) if representation_field.type

      if representation_field.elements_type
        representation.merge!({ elements_type: representation_field.elements_type })
      end

      representation
    end

  end
end
