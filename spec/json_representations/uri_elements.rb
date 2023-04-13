module JsonRepresentations
  module UriElements

    def uri_element_representation(uri_element)
      {
        :element => uri_element.name,
        :description => uri_element.description
      }
    end

  end
end
