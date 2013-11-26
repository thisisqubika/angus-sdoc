module Angus
  module SDoc
    class Definitions::Operation

      # @!attribute [rw] name
      #   @return [String] the name of the operation.
      attr_accessor :name

      # @!attribute [rw] code_name
      #   @return [String] the code name of the message. It is a human readable unique identifier.
      #     It has to start with Mayus and it has to be camelcase.
      attr_accessor :code_name

      # @!attribute [rw] description
      #   @return [String] the description of the operation.
      attr_accessor :description

      # @!attribute [rw] path
      #   @return [String] the path of the operation.
      attr_accessor :path

      # @!attribute [rw] http_method
      #   @return [String] the HTTP method of the operation.
      attr_accessor :http_method

      # @!attribute [rw] messages
      #   @return [Hash<String, Message>] the messages associated with the operation.
      attr_accessor :messages

      # @!attribute [rw] uri_elements
      #   @return [Set<UriElement>] the uri elements of the operation.
      attr_accessor :uri_elements

      # @!attribute [rw] request_elements
      #   @return [Set<RequestElement>] the request elements of the operation.
      attr_accessor :request_elements

      # @!attribute [rw] response_elements
      #   @return [Set<ResponseElement>] the response elements of the operation.
      attr_accessor :response_elements

      def code_name
        @code_name.split('.')[-1]
      end

      # Returns the first message that matches the given key and level.
      #
      # @param [String] key The key of the message.
      # @param [String] level The level of the message.
      #   Possible values are the *_LEVEL constants from {Message}.
      #
      # @return [Message] the message or nil if no one matches.
      def message(key, level)
        return nil if self.messages.nil?

        level &&= level.downcase
        self.messages.find { |message| message.key == key && message.level.downcase == level }
      end

    end
  end
end
