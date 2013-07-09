module Picasso
  module SDoc

    class Definitions::Message

      ERROR_LEVEL = 'error'
      INFO_LEVEL = 'info'
      WARNING_LEVEL = 'warning'

      attr_accessor :level
      attr_accessor :key
      attr_accessor :description
      attr_accessor :status_code

      # Text to be write into the response as description
      attr_accessor :text

    end

  end
end