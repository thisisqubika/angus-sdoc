module Angus
  module SDoc
    class Definitions::Message

      ERROR_LEVEL = 'error'
      INFO_LEVEL = 'info'
      WARNING_LEVEL = 'warning'

      # @!attribute [rw] level
      #   @return [String] the level of the message. Possible values are the *_LEVEL constants.
      attr_accessor :level

      # @!attribute [rw] key
      #   @return [String] the key of the message. It is a human readable unique identifier.
      #     It has to start with Mayus and it has to be camelcase.
      attr_accessor :key

      # @!attribute [rw] description
      #   @return [String] the description of the message.
      attr_accessor :description

      # @!attribute [rw] status_code
      #   @return [String] the HTTP status code of the message.
      attr_accessor :status_code

      # @!attribute [rw] text
      #   @return [String] when set this text overrides all others and is set as the message description.
      attr_accessor :text
    end
  end
end