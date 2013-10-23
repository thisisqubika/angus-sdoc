module Angus
  module SDoc
    class Definitions::Service

      # @!attribute [rw] name
      #   @return [String] the name of the sevice.
      attr_accessor :name

      # @!attribute [rw] code_name
      #   @return [String] the service code name is a unique identifier.
      #     It has to be human-readable and a valid literal identifier.
      attr_accessor :code_name

      # @!attribute [rw] version
      #   @return [String] the version of the sevice.
      attr_accessor :version

      # @!attribute [rw] messages
      #   @return [Hash<String, Message>] the messages associated with the service.
      attr_accessor :messages

      # @!attribute [rw] operations
      #   @return [Set<Operation>] the operations of the service.
      attr_accessor :operations

      # @!attribute [rw] proxy_operations
      #   @return [Set<ProxyOperation>] the proxy operations of the service.
      attr_accessor :proxy_operations

      # @!attribute [rw] representations
      #   @return [Set<Representation>] the representations of the service.
      attr_accessor :representations

      # @!attribute [rw] glossary
      #   @return [Glossary] the glossary of the service.
      attr_accessor :glossary

      def initialize
        @messages = {}
        @operations = Set.new
        @representations = Set.new
        @glossary = Angus::SDoc::Definitions::Glossary.new
      end

      # Returns the message that matches the given key and level.
      #
      # This method searches for messages in all the operations and returns
      # the first message that matches.
      #
      # @param [#to_s] key The key of the message.
      # @param [String] level The level of the message
      #   Possible values are the *_LEVEL constants from {Message}
      #
      # @return [Message] the message or nil if no one matches.
      def message(key, level)
        msg = nil

        @operations.find do |operation|
          msg = operation.message(key.to_s, level)
        end

        msg
      end

      # Merge the following definitions:
      #  - Operations.
      #  - Representations.
      #  - Messages.
      #
      # @note This method does not merge glossary terms.
      #
      # @param [Service] other The service to be merged.
      def merge(other)
        self.operations.merge!(other.operations)
        self.representations += other.representations

        self.messages.merge!(other.messages)
      end

      # Returns the operation definition that matches with the given operation name.
      #
      # @param operation_code_name The operation code name.
      #
      # @return [Operation] The operation.
      def operation_definition(namespace, operation_code_name)
        @operations[namespace].find { |operation| operation.code_name == operation_code_name }
      end

      # Returns the proxy operations for a given service.
      # @todo Does it receives the service or the service name?
      # @todo Verify if this method is being called by remote-client and if it receives
      #   the service name.
      # @param service The service name.
      # @return [Array<ProxyOperation>] The proxy operations.
      def proxy_operations_for(service)
        self.proxy_operations.select do |op|
          op.service_name == service
        end
      end

      # Returns a hash with the representations.
      # @example
      #  {
      #    key => rollback_payment_multi,
      #    value => {representation}
      #  }
      # @return [Hash<String, Representation>] The representation hash.
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