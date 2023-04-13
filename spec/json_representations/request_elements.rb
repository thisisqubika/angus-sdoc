module JsonRepresentations
  module RequestElements

    def request_element_representation(request_element)
      representation = {
        :element => request_element.name,
        :description => request_element.description,
        :required => request_element.required
      }

      representation.merge!({:type => request_element.type}) if request_element.type

      if request_element.elements_type
        representation.merge!({:elements_type => request_element.elements_type})
      end

      representation
    end

  end
end
