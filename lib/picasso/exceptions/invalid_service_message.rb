module Picasso
  module SDoc

    class InvalidServiceMessage < StandardError

      attr_accessor :error_message, :message_key

      def initialize(message_key, error_message)
        self.error_message= error_message
        self.message_key= message_key
      end

      def error_key
        self.class.name
      end

      def message
        "#@message_key => #@error_message"
      end

      def to_s
        message
      end

      def == (other)
        other.kind_of?(InvalidServiceMessage) &&
          other.message == self.message && self.message_key == other.message_key
      end

    end
  end
end