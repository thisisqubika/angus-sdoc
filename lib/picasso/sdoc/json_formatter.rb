require 'json'

module Picasso
  module SDoc
    class JsonFormatter

      def self.format(x)
        define_singleton_method("format_#{x}") do |y|
          JSON(send("#{x}_for_json", y))
        end
      end

      format :glossary
      format :glossary_term
      format :message
      format :operation
      format :proxy_operation
      format :representation
      format :representation_field
      format :request_element
      format :response_element
      format :service
      format :uri_element

      class << self
        private

        # Returns a hash with the glossary data.
        #
        # @param [Picasso::SDoc::Definitions::Glossary] glossary_definition
        #   The glossary definition.
        #
        # @return [Hash]
        # @option return [(see .glossary_term_for_json)] :<term.short_name>
        def glossary_for_json(glossary_definition)
          glossary_definition.terms.inject({}) do |result, term|
            result.merge({ term.short_name => glossary_term_for_json(term) })
          end
        end

        # Returns a hash with the glossary term data.
        #
        # @param [Picasso::SDoc::Definitions::GlossaryTerm] glossary_term_definition
        #   The glossary term definition.
        #
        # @return [Hash]
        # @option return [String] :long_name
        # @option return [String] :description
        def glossary_term_for_json(glossary_term_definition)
          {
            :long_name => glossary_term_definition.long_name,
            :description => glossary_term_definition.description
          }
        end

        # Returns a hash with the message data.
        #
        # @param [Picasso::SDoc::Definitions::Message] message_definition
        #   The message definition.
        #
        # @return [Hash]
        # @option return [String] :key
        # @option return [String] :description
        # @option return [String] :level
        # @option return [Integer] :status_code
        def message_for_json(message_definition)
          {
            :key => message_definition.key,
            :description => message_definition.description,
            :level => message_definition.level,
            :status_code => message_definition.status_code
          }
        end

        # Returns a hash with the operation data.
        #
        # @param [Picasso::SDoc::Definitions::Operation] operation_definition
        #   The operation definition.
        #
        # @return [Hash]
        # @option return [String] :name
        # @option return [String] :description
        # @option return [String] :path
        # @option return [String] :method
        # @option return [Array<(see .uri_element_for_json)>] :uri
        # @option return [Array<(see .request_element_for_json)>] :request
        # @option return [Array<(see .response_element_for_json)>] :response
        # @option return [Array<(see .message_for_json)>] :messages
        def operation_for_json(operation_definition)
          data = {
            :name => operation_definition.name,
            :description => operation_definition.description,
            :path => operation_definition.path,
            :method => operation_definition.method
          }

          if operation_definition.uri_elements && !operation_definition.uri_elements.empty?
            uri_elements = operation_definition.uri_elements.map do |uri_element|
              uri_element_for_json(uri_element)
            end
            data.merge!({ :uri => uri_elements })
          end

          if operation_definition.request_elements && !operation_definition.request_elements.empty?
            request_elements = operation_definition.request_elements.map do |request_element|
              request_element_for_json(request_element)
            end

            data.merge!({ :request => request_elements })
          end

          if operation_definition.response_elements && !operation_definition.response_elements.empty?
            response_elements = operation_definition.response_elements.map do |response_element|
              response_element_for_json(response_element)
            end

            data.merge!({:response => response_elements})
          end

          if operation_definition.messages && !operation_definition.messages.empty?
            messages = operation_definition.messages.map do |message|
              message_for_json(message)
            end

            data.merge!({:messages => messages})
          end

          data
        end

        # Returns a hash with the proxy operation data.
        #
        # @param [Picasso::SDoc::Definitions::ProxyOperation] proxy_operation_definition
        #   The proxy operation definition.
        #
        # @return [Hash]
        # @option return [String] :path
        # @option return [String] :method
        # @option return [String] :service
        def proxy_operation_for_json(proxy_operation_definition)
          {
            :path => proxy_operation_definition.path,
            :method => proxy_operation_definition.method,
            :service => proxy_operation_definition.service_name
          }
        end

        # Returns a hash with the representation data.
        #
        # @param [Picasso::SDoc::Definitions::Representation] representation_definition
        #   The representation definition.
        #
        # @return [Array<(see .representation_field_for_json)>]
        def representation_for_json(representation_definition)
          representation_definition.fields.map do |field|
            representation_field_for_json(field)
          end
        end

        # Returns a hash with the representation field data.
        #
        # @param [Picasso::SDoc::Definitions::RepresentationField] representation_field_definition
        #   The representation field definition.
        #
        # @return [Hash]
        # @option return [String] :element
        # @option return [String] :description
        # @option return [Boolean] :required
        # @option return [String] :type
        # @option return [String] :elements_type
        def representation_field_for_json(representation_field_definition)
          data = {
            :field => representation_field_definition.name,
            :description => representation_field_definition.description,
            :required => representation_field_definition.required
          }

          if representation_field_definition.type
            data.merge!({:type => representation_field_definition.type})
          end

          if representation_field_definition.elements_type
            data.merge!({:elements_type => representation_field_definition.elements_type})
          end

          data
        end

        # Returns a hash with the request element data.
        #
        # @param [Picasso::SDoc::Definitions::RequestElement] request_element_definition
        #   The request element definition.
        #
        # @return [Hash]
        # @option return [String] :element
        # @option return [String] :description
        # @option return [Boolean] :required
        # @option return [String] :type
        # @option return [String] :elements_type
        def request_element_for_json(request_element_definition)
          data = {
            :element => request_element_definition.name,
            :description => request_element_definition.description,
            :required => request_element_definition.required
          }

          if request_element_definition.type
            data.merge!({:type => request_element_definition.type})
          end

          if request_element_definition.elements_type
            data.merge!({:elements_type => request_element_definition.elements_type})
          end

          data
        end

        # Returns a hash with the response element data.
        #
        # @param [Picasso::SDoc::Definitions::ResponseElement] response_element_definition
        #   The response element definition.
        #
        # @return [Hash]
        # @option return [String] :element
        # @option return [String] :description
        # @option return [Boolean] :required
        # @option return [String] :type
        # @option return [String] :elements_type
        def response_element_for_json(response_element_definition)
          data = {
            :element => response_element_definition.name,
            :description => response_element_definition.description,
            :required => response_element_definition.required
          }

          if response_element_definition.type
            data.merge!({:type => response_element_definition.type})
          end

          if response_element_definition.elements_type
            data.merge!({:elements_type => response_element_definition.elements_type})
          end

          data
        end

        # Generates the json for the service definition.
        #
        # @param [Picasso::SDoc::Definitions::Service] service_definition
        #   The service definition.
        #
        # @return [Hash]
        # @option return [Hash] :service
        # @option :service [String] :service
        # @option :service [String] :code_name
        # @option :service [String] :version
        # @option return [Hash<(see .uri_element_for_json)>] :operations
        # @option return [Hash<(see .request_element_for_json)>] :proxy_operations
        # @option return [Hash<(see .response_element_for_json)>] :representations
        # @option return [Array<(see .message_for_json)>] :messages
        # @option return [(see .message_for_json)] :glossary
        def service_for_json(service_definition)
          operations = service_definition.operations.inject({}) do |result, operation|
            result.merge({operation.code_name => operation_for_json(operation)})
          end

          proxy_operations = service_definition.proxy_operations.inject({}) do |result, operation|
            result.merge({operation.code_name => proxy_operation_for_json(operation)})
          end

          representations = service_definition.representations.inject({}) do |result, representation|
            result.merge({representation.name => representation_for_json(representation)})
          end

          messages = service_definition.messages.map do |message_name, message|
            message_for_json(message)
          end

          {
            :service => {
              :service => service_definition.name,
              :code_name => service_definition.code_name,
              :version => service_definition.version
            },
            :operations => operations,
            :proxy_operations => proxy_operations,
            :representations => representations,
            :messages => messages,
            :glossary => glossary_for_json(service_definition.glossary)
          }
        end

        # Returns a hash with the uri element data.
        #
        # @param [Picasso::SDoc::Definitions::UriElement] uri_element_definition
        #   The uri element definition.
        #
        # @return [Hash]
        # @option return [String] :element
        # @option return [String] :description
        def uri_element_for_json(uri_element_definition)
          {
            :element => uri_element_definition.name,
            :description => uri_element_definition.description
          }
        end

      end

    end
  end
end