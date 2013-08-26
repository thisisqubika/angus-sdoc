require_relative 'uri_elements'
require_relative 'response_elements'
require_relative 'request_elements'
require_relative 'messages'

module JsonRepresentations
  module Operations
    include Messages
    include UriElements
    include RequestElements
    include ResponseElements

    def operation_representation(operation)
      {}

      representation = {
        :name => operation.name,
        :description => operation.description,
        :path => operation.path,
        :method => operation.method
      }

      if operation.uri_elements && !operation.uri_elements.empty?
        representation.merge!({:uri => operation.uri_elements.map { |uri_element| uri_element_representation(uri_element) } })
      end

      if operation.request_elements && !operation.request_elements.empty?
        representation.merge!({:request => operation.request_elements.map { |request_element| request_element_representation(request_element) } })
      end

      if operation.response_elements && !operation.response_elements.empty?
        representation.merge!({:response => operation.response_elements.map { |response_element| response_element_representation(response_element) } })
      end

      if operation.messages && !operation.messages.empty?
        representation.merge!({ :messages => operation.messages.map { |message| message_representation(message) } })
      end

      representation
    end

  end
end