module Picasso
  module SDoc
    module DefinitionsUtils

      # Builds a new definition hash based on the given operation names.
      # @todo Explain better this method. Needs refactor?
      #
      # @param [Hash] definition The service definition.
      # @param [Array<String>] operation_names The names of the operations.
      #
      # @return [Hash] the definition.
      def self.slice(definition, operation_names)
        result = {
          :operations => {},
          :representations => {},
          :messages => {}
        }

        result[:service] = definition['service']

        representations = Set.new
        messages = Set.new

        definition['operations'].each do |code_name, operation|
          if operation_names.include?(code_name)
            result[:operations][code_name] = operation

            types = (operation['response'] || []).map do |element|
              element['type'] || element['elements_type']
            end

            representations += types

            messages += (operation['messages'] || []).map do |message|
              message['key']
            end

          end
        end

        representations.each do |name|
          include_representation(name, definition['representations'], result[:representations])
        end

        messages.each do |key|
          result[:messages][key] = definition['messages'][key]
        end

        result
      end

      # Inserts a representation and its children into a destination.
      #
      # @note The purpose of this method is to be used as an utility method from a method which
      #   selects a subset of representations.
      #
      # @param [String] name The representation name.
      # @param [Hash] representations The source of the representations.
      # @param [Hash] into the destination hash.
      def self.include_representation(name, representations, into)
        if representation = representations[name]
          into[name] = representation
          representation.each do |field|
            field_type = field['type'] || field['elements_type']
            include_representation(field_type, representations, into)
          end
        end
      end

    end
  end
end
