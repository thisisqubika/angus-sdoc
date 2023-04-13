module Angus
  module SDoc
    class DefinitionsReader

      OPERATIONS = 'operations'
      CONFIGURATIONS = %w{service proxy_operations representations glossary messages}

      class << self

        # Returns the tree of objects for the service.
        #
        # @param [String] base_path The base path of the YML files.
        #
        # @return [Angus::SDoc::Definitions::Service] The service definition.
        def service_definition(base_path)
          definition_hash = load_definitions(base_path)

          build_service_definition(definition_hash)
        end

        # It builds a Definitions::Service object from a service metadata.
        #
        # @param [Hash] definition_hash The service metadata.
        #
        # @return [Angus::SDoc::Definitions::Service] The service definition.
        def build_service_definition(definition_hash)
          definition = Angus::SDoc::Definitions::Service.new
          definition.name = definition_hash['service']['service']
          definition.code_name = definition_hash['service']['code_name']
          definition.version = definition_hash['service']['version']

          if definition_hash['messages']
            definition.messages = build_messages(definition_hash['messages'])
          end

          if definition_hash['representations']
            definition.representations = build_representations(definition_hash['representations'])
          end

          operations_hash = definition_hash['operations'] || {}
          definition.operations = build_operations(
            operations_hash,
            definition.messages
          )

          definition.proxy_operations = build_proxy_operations(
            # As long as services uses a Angus version which don't support proxy operations,
            # we should default to an empty array.
            #
            # Remove the default when all services update Angus gem.
            definition_hash['proxy_operations'] || []
          )

          if definition_hash['glossary']
            definition.glossary = build_glossary(definition_hash['glossary'])
          end

          definition
        end

        # Reads the YML files in the given base path and returns a hash with the results loaded.
        def load_definitions(base_path)
          loaded_files = []

          result = {}

          Dir["#{base_path}/{#{CONFIGURATIONS.join(',')}}.yml"].each do |config_file|
            loaded_files << config_file

            namespace = File.basename(config_file, '.*')

            result[namespace] = YAML.load_file(config_file) || {}
          end

          Dir["#{base_path}/**/#{OPERATIONS}.yml"].each do |config_file|
            unless loaded_files.include?(config_file)
              loaded_files << config_file

              namespace = File.basename(config_file, '.*')

              operation_namespace = Pathname.new(File.dirname(config_file)).basename.to_s
              operation           = YAML.load_file(config_file)

              result[namespace] ||= {}
              result[namespace][operation_namespace] = operation
            end
          end

          result
        end
        private :load_definitions

        # Builds Definitions::Message objects for each message metadata.
        #
        # @param [Hash] messages_hash The metadata messages.
        # @example metadata message example
        #   {'InvalidJsonError' =>
        #     {
        #       'status_code' => 422,
        #       'level'       => 'error',
        #       'description' => 'Invalid json'
        #     }
        #   }
        #
        # @return [Hash<String, Message>] The hash with the messages.
        def build_messages(messages_hash)
          messages = {}

          messages_hash.each do |key, attrs|
            messages[key] = build_message(key, attrs['level'], attrs['status_code'],
                                          attrs['description'], attrs['text'], attrs['fields'])
          end

          messages
        end
        private :build_messages

        # Builds Definitions::Message with the message data.
        #
        # @param [String] key The message key.
        # @param [String] level The message level.
        # @param [String] status_code The message status code.
        # @param [String] description The message description.
        # @param [String] text The message text.
        #
        # @raise [Angus::SDoc::InvalidServiceMessage] if the level or the status code
        #   was not specified.
        #
        # @return [Message] the message.
        def build_message(key, level, status_code, description, text, fields)
          unless level
            raise Angus::SDoc::InvalidServiceMessage.new(key ,'Can not create message without level.')
          end

          unless status_code
            raise Angus::SDoc::InvalidServiceMessage.new(key , 'Can not create message without a status code.')
          end

          message = Angus::SDoc::Definitions::Message.new
          message.key = key
          message.level = level
          message.status_code = status_code
          message.description = description
          message.text = text
          message.fields = (fields || []).map { |field| build_message_field(field['name'],
                                                                            field['description'],
                                                                            field['type'],
                                                                            field['elements_type'],
                                                                            field['required']) }

          message
        end
        private :build_message

        # Builds Definitions::Field with the message data.
        #
        # @param [String] key The message key.
        # @param [String] level The message level.
        # @param [String] status_code The message status code.
        # @param [String] description The message description.
        # @param [String] text The message text.
        #
        # @raise [Angus::SDoc::InvalidServiceMessage] if the level or the status code
        #   was not specified.
        #
        # @return [Message] the message.
        def build_message_field(name, description, type, elements_type, required)
          field = Angus::SDoc::Definitions::MessageField.new
          field.name = name
          field.description = description
          field.type = type
          field.elements_type = elements_type
          field.required = required

          field
        end
        private :build_message_field

        # Builds Definitions::ProxyOperation objects for each proxy operation metadata.
        #
        # @param [Hash] proxy_operations_hash The proxy operations metadata.
        def build_proxy_operations(proxy_operations_hash)
          proxy_operations_hash.map do |code_name, fields|
            proxy_op = Angus::SDoc::Definitions::ProxyOperation.new
            proxy_op.code_name = code_name

            proxy_op.path = fields['path']
            proxy_op.http_method = fields['method']
            proxy_op.service_name = fields['service']

            proxy_op
          end
        end
        private :build_proxy_operations

        # Builds Definitions::Representation objects for each representation metadata.
        #
        # @param [Hash] representations_hash The representations metadata.
        # @option [String] :name
        # @option [String] :field
        # @option [String] :description
        # @option [String] :type
        # @option [String] :required
        # @option [String] :elements_type
        def build_representations(representations_hash)
          representations_hash.map do |name, fields|
            representation = Angus::SDoc::Definitions::Representation.new
            representation.name = name

            representation.fields = fields.map do |field_hash|
              field = Angus::SDoc::Definitions::RepresentationField.new
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
        private :build_representations

        # @todo Clarify the method explaining in a better way the note.
        # @todo Refactor?
        # Builds Definitions::Operation objects for each operation metadata.
        #
        # @note It also builds and associates:
        #   - request elements
        #   - uri elements
        #   - messages
        #   - response elements
        #
        # @param [Hash] operations_hash The operations' metadata.
        # @param [Array<Message>] messages The service messages.
        #
        # @return [Hash<String, Array<Operation>>] hash with namespace as key and a list of
        #   operations as values.
        def build_operations(operations_hash, messages)
          result = {}

          operations_hash.each do |namespace, operations|
            operations = {} unless operations.is_a?(Hash)

            operations.each do |code_name, op_metadata|
              operation = Angus::SDoc::Definitions::Operation.new

              operation.name = op_metadata['name']
              operation.code_name = code_name
              operation.description = op_metadata['description']
              operation.path = op_metadata['path']
              operation.http_method = op_metadata['method']

              op_metadata['uri'] ||= []
              operation.uri_elements = op_metadata['uri'].map do |element_hash|
                uri_element = Angus::SDoc::Definitions::UriElement.new

                uri_element.name = element_hash['element']
                uri_element.description = element_hash['description']

                uri_element
              end

              op_metadata['request'] ||= []
              operation.request_elements = op_metadata['request'].map do |element_hash|
                request_element = Angus::SDoc::Definitions::RequestElement.new

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
                response_element = Angus::SDoc::Definitions::ResponseElement.new

                response_element.name = element_hash['element']
                response_element.description = element_hash['description']
                response_element.required = element_hash['required']
                response_element.type = element_hash['type']
                response_element.default = element_hash['default']
                response_element.elements_type = element_hash['elements_type']

                response_element
              end

              result[namespace] ||= []
              result[namespace] << operation
            end
          end

          result
        end
        private :build_operations

        # Builds a glossary from a hash.
        #
        # @param [Hash<String, Hash>] glossary_hash The hash contains GlossaryTerm#short_name
        #   as the key and a hash containing GlossaryTerm#long_name and GlossaryTerm#description
        #   as a value.
        # @return [Glossary] the glossary
        def build_glossary(glossary_hash)
          Angus::SDoc::Definitions::Glossary.new(glossary_hash)
        end
        private :build_glossary

      end

    end
  end
end
