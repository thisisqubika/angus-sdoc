module Picasso
  module SDoc
    class Definitions::ResponseElement

      # @!attribute [rw] name
      #   @return [String] the name of the response element.
      attr_accessor :name

      # @!attribute [rw] description
      #   @return [String] the description of the response element.
      attr_accessor :description

      # @!attribute [rw] required
      #   @return [Boolean] indicates if the response element is required or not.
      attr_accessor :required

      # @!attribute [rw] type
      #   @return [String] the type of the response element.
      attr_accessor :type

      # @!attribute [rw] default
      #   @return [String] the default value of the response element.
      attr_accessor :default

      # @!attribute [rw] elements_type
      #   @return [String] the elements type of the response element.
      attr_accessor :elements_type

      def initialize(name = nil, description = nil, required = nil, type = nil, default = nil,
                     elements_type = nil)
        @name = name
        @description = description
        @required = required
        @type = type
        @default = default
        @elements_type = elements_type
      end

    end
  end
end