module Picasso
  module SDoc
    class Definitions::Service

      attr_accessor :name
      attr_accessor :code_name
      attr_accessor :version
      attr_accessor :messages
      attr_accessor :operations
      attr_accessor :proxy_operations
      attr_accessor :representations
      attr_accessor :glossary

      def initialize
        @messages = {}
        @operations = Set.new
        @representations = Set.new
        @glossary = Picasso::SDoc::Definitions::Glossary.new
      end

      # Returns the message that matches the given key and level
      #
      # This method searches for messages in all the operations and returns
      #  the first message that matches.
      #
      # @param [#to_s] key The key of the message
      # @param [String] level The level of the message
      #   Possible values are the *_LEVEL constants from {Message}
      #
      # @return [Message] The message or nil if no one matches
      def message(key, level)
        msg = nil

        @operations.find do |operation|
          msg = operation.message(key.to_s, level)
        end

        msg
      end

      # Merge the following definitions:
      #  - operations
      #  - representations
      #  - messages
      #
      # @note This method does not merge glossary terms.
      #
      # @param [Definitions::Service] other
      def merge(other)
        self.operations += other.operations
        self.representations += other.representations

        self.messages.merge!(other.messages)
      end

      # Returns the operation definition that corresponds to operation_name
      def operation_definition(operation_code_name)
        @operations.find { |operation| operation.code_name == operation_code_name }
      end

      def proxy_operations_for(service)
        self.proxy_operations.select do |op|
          op.service_name == service
        end
      end

      # Returns a hash with:
      #  - key => representation name
      #  - value => representation
      def representations_hash
        hash = {}
        @representations.each do |representation|
          hash[representation.name] = representation
        end
        hash
      end

    end
  end
end