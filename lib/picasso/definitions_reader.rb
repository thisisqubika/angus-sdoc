module Picasso
  module SDoc

    class DefinitionsReader

      CONFIGURATIONS = %w{service operations proxy_operations representations glossary messages}

      class << self

        def load_definitions(base_path)
          result = {}

          Dir["#{base_path}/{#{CONFIGURATIONS.join(',')}}.yml"].each do |config_file|
            namespace = File.basename(config_file, '.*')

            result[namespace] = load_yaml(config_file)
          end

          result
        end
        private :load_definitions

        def load_yaml(file, default = {})
          v = begin
            YAML.load_file(file) || default
          rescue
          end

          v || default
        end
        private :load_yaml

      end

      # Returns the service definition
      #
      # It reads the definition .yml files and then it builds the tree of objects for the service
      def self.service_definition(base_path)
        definition_hash = load_definitions(base_path) #service_definition_hash

        self.build_service_definition(definition_hash)
      end

      # Reads and parses the .yml definition files and returns a hash with the contents
      #def self.service_definition_hash
      #  service_hash = load_yaml(SERVICE_FILE)
      #  operations_hash = load_yaml(OPERATIONS_FILE)
      #  proxy_operations_hash = load_yaml(PROXY_OPERATIONS_FILE)
      #  representations_hash = load_yaml(REPRESENTATIONS_FILE)
      #  glossary_hash = load_yaml(GLOSSARY_FILE)
      #  messages_hash = load_yaml(MESSAGES_FILE)
      #
      #  return {
      #    'service' => service_hash,
      #    'operations' => operations_hash,
      #    'proxy_operations' => proxy_operations_hash,
      #    'representations' => representations_hash,
      #    'glossary' => glossary_hash,
      #    'messages' => messages_hash,
      #  }
      #end



      # It builds a Definitions::Service object from a definition hash
      #
      # @param [Hash] definition_hash the service metadata
      def self.build_service_definition(definition_hash)
        definition = Picasso::SDoc::Definitions::Service.new
        definition.name = definition_hash['service']['service']
        definition.code_name = definition_hash['service']['code_name']
        definition.version = definition_hash['service']['version']

        if definition_hash['messages']
          definition.messages = build_messages(definition_hash['messages'])
        end

        if definition_hash['representations']
          definition.representations = build_representations(definition_hash['representations'])
        end

        definition.operations = build_operations(
          definition_hash['operations'],
          definition.messages
        )

        definition.proxy_operations = build_proxy_operations(
          # As long as services uses a picasso version which don't support proxy operations,
          # we should default to an empty array.
          #
          # Remove the default when all services update bancard-picasso gem.
          definition_hash['proxy_operations'] || []
        )

        if definition_hash['glossary']
          definition.glossary = build_glossary(definition_hash['glossary'])
        end

        definition
      end

      private

      # Builds Definitions::Message objects for each message metadata
      #
      # @param [Hash] messages_hash Hash of messages metadata
      #
      # @return [Hash<String, Message>]
      def self.build_messages(messages_hash)
        messages = {}

        messages_hash.each do |key, attrs|
          messages[key] = build_message(key, attrs['level'], attrs['status_code'],
                                        attrs['description'], attrs['text'])
        end

        messages
      end

      # Builds Definitions::Message with the message data.
      #
      # @param [String] key
      # @param [String] level
      # @param [String] status_code
      # @param [String] description
      # @param [String] text
      #
      # @return [Message]
      def self.build_message(key, level, status_code, description, text)
        unless level
          raise InvalidServiceMessage.new(key ,'Can not create message without level.')
        end

        unless status_code
          raise InvalidServiceMessage.new(key , 'Can not create message without a status code.')
        end

        message = Picasso::SDoc::Definitions::Message.new
        message.key = key
        message.level = level
        message.status_code = status_code
        message.description = description
        message.text = text

        message
      end

      # Builds Definitions::ProxyOperation objects for each proxy operation metadata.
      #
      # @param [Hash] representations_hash Hash of proxy operations metadata
      def self.build_proxy_operations(proxy_operations_hash)
        proxy_operations_hash.map do |code_name, fields|
          proxy_op = Picasso::SDoc::Definitions::ProxyOperation.new
          proxy_op.code_name = code_name

          proxy_op.path = fields['path']
          proxy_op.method = fields['method']
          proxy_op.service_name = fields['service']

          proxy_op
        end
      end

      # Builds Definitions::Representation objects for each representation metadata
      #
      # @param [Hash] representations_hash Hash of representations metadata
      def self.build_representations(representations_hash)
        representations_hash.map do |name, fields|
          representation = Picasso::SDoc::Definitions::Representation.new
          representation.name = name

          representation.fields = fields.map do |field_hash|
            field = Picasso::SDoc::Definitions::RepresentationField.new
            field.name = field_hash['field']
            field.description = field_hash['description']
            field.type = field_hash['type']
            field.required = field_hash['required']
            field.elements_type = field_hash['elements_type']
            field
          end

          representation
        end
      end

      # Builds Definitions::Operation objects for each operation metadata
      #
      # It also builds and associates:
      # - request elements
      # - uri elements
      # - messages
      # - response elements
      #
      # @param [Hash] operations_hash Hash of operations metadata
      # @param [Array<Message>] messages Hash of service messages
      #
      # @return [Array<Operation>]
      def self.build_operations(operations_hash, messages)
        operations_hash.map do |code_name, op_metadata|
          operation = Picasso::SDoc::Definitions::Operation.new

          operation.name = op_metadata['name']
          operation.code_name = code_name
          operation.description = op_metadata['description']
          operation.path = op_metadata['path']
          operation.method = op_metadata['method']

          op_metadata['uri'] ||= []
          operation.uri_elements = op_metadata['uri'].map do |element_hash|
            uri_element = Picasso::SDoc::Definitions::UriElement.new

            uri_element.name = element_hash['element']
            uri_element.description = element_hash['description']

            uri_element
          end

          op_metadata['request'] ||= []
          operation.request_elements = op_metadata['request'].map do |element_hash|
            request_element = Picasso::SDoc::Definitions::RequestElement.new

            request_element.name = element_hash['element']
            request_element.description = element_hash['description']
            request_element.required = element_hash['required']
            request_element.type = element_hash['type']
            request_element.constraints = element_hash['constraints']
            request_element.valid_values = element_hash['valid_values']
            request_element.elements_type = element_hash['elements_type']

            request_element
          end

          op_metadata['messages'] ||= []
          operation.messages = op_metadata['messages'].map do |message_hash|
            message_key = message_hash['key']

            message = messages[message_key]

            if message
              # The operation could override some description or level attributes, so we clone it
              message = message.clone
              message.description = message_hash['description'] if message_hash['description']
              message.level = message_hash['level'] if message_hash['level']
            else
              message = build_message(message_key, message_hash['level'], message_hash['status_code'],
                                      message_hash['description'], message_hash['text'])
            end

            message
          end

          op_metadata['response'] ||= []
          operation.response_elements = op_metadata['response'].map do |element_hash|
            response_element = Picasso::SDoc::Definitions::ResponseElement.new

            response_element.name = element_hash['element']
            response_element.description = element_hash['description']
            response_element.required = element_hash['required']
            response_element.type = element_hash['type']
            response_element.default = element_hash['default']
            response_element.elements_type = element_hash['elements_type']

            response_element
          end

          operation
        end
      end

      # Builds a glossary from a glossary_hash
      #
      # @param [Hash] glossary_hash the definition hash of the glossary
      #
      # @return [Glossary]
      def self.build_glossary(glossary_hash)
        glossary = Picasso::SDoc::Definitions::Glossary.new

        terms = glossary_hash.map do |short_name, term_hash|
          glossary_term = Picasso::SDoc::Definitions::GlossaryTerm.new

          glossary_term.short_name = short_name
          glossary_term.long_name = term_hash['long_name']
          glossary_term.description = term_hash['description']

          glossary_term
        end

        glossary.terms = terms
        glossary
      end

    end

  end
end