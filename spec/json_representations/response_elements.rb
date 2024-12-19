module JsonRepresentations
  module ResponseElements

    def response_element_representation(response_element)
      representation = {
        element: response_element.name,
        description: response_element.description,
        required: response_element.required,
        optional: response_element.optional
      }

      representation.merge!({ type: response_element.type }) if response_element.type

      if response_element.elements_type
        representation.merge!({ elements_type: response_element.elements_type })
      end

      representation
    end

  end
end
