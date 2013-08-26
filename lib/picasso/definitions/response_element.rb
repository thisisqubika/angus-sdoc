module Picasso
  module SDoc
    class Definitions::ResponseElement

      attr_accessor :name
      attr_accessor :description
      attr_accessor :required
      attr_accessor :type
      attr_accessor :default
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