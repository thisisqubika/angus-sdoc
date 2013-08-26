module Picasso
  module SDoc
    class Definitions::UriElement

      attr_accessor :name
      attr_accessor :description

      def initialize(name = nil, description = nil)
        @name = name
        @description = description
      end

    end
  end
end