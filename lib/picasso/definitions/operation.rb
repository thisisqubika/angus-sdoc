module Picasso
  module SDoc

    class Definitions::Operation
      attr_accessor :name
      attr_accessor :code_name
      attr_accessor :description
      attr_accessor :path
      attr_accessor :method

      attr_accessor :messages

      attr_accessor :uri_elements
      attr_accessor :request_elements
      attr_accessor :response_elements

      # Returns the first message that matches the given key and level.
      #
      # @param [String] key the key of the message.
      # @param [String] level the level of the message.
      #   Possible values are the *_LEVEL constants from {Message}.
      #
      # @return [Message] the message or nil if no one matches
      def message(key, level)
        return nil if self.messages.nil?

        level &&= level.downcase
        self.messages.find { |message| message.key == key && message.level.downcase == level }
      end
    end

  end
end
