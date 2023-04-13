module Angus
  module SDoc
    class Definitions::MessageField

      # @!attribute [rw] name
      #   @return [String] the name of the message field.
      attr_accessor :name

      # @!attribute [rw] description
      #   @return [String] the description of the message field.
      attr_accessor :description

      # @!attribute [rw] required
      #   @return [Boolean] indicates if the message field. is required or not.
      attr_accessor :required

      # @!attribute [rw] type
      #   @return [String] the type of the message field.
      attr_accessor :type

      # @!attribute [rw] elements_type
      #   @return [String] the elements type of the message field.
      attr_accessor :elements_type

    end
  end
end
