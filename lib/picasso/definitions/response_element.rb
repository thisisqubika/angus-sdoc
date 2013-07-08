module Picasso
  module SDoc

    class Definitions::RequestElement
      attr_accessor :name
      attr_accessor :description
      attr_accessor :required
      attr_accessor :type
      attr_accessor :constraints
      attr_accessor :valid_values
      attr_accessor :elements_type
    end

  end
end