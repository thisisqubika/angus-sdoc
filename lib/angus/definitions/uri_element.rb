module Angus
  module SDoc
    class Definitions::UriElement

      # @!attribute [rw] name
      #   @return [String] the name of the uri element.
      attr_accessor :name

      # @!attribute [rw] description
      #   @return [String] the description of the uri element.
      attr_accessor :description

      def initialize(name = nil, description = nil)
        @name = name
        @description = description
      end

    end
  end
end
