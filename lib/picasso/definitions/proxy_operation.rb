module Picasso
  module SDoc
    class Definitions::ProxyOperation

      # @!attribute [rw] code_name
      #   @return [String] the code name of the message. It is a human readable unique identifier.
      #     It has to start with Mayus and it has to be camelcase.
      attr_accessor :code_name

      # @!attribute [rw] path
      #   @return [String] the path of the operation.
      attr_accessor :path

      # @!attribute [rw] method
      #   @return [String] the HTTP method of the operation.
      attr_accessor :method

      # @!attribute [rw] service_name
      #   @return [String] the service name of the operation.
      attr_accessor :service_name

      # @!attribute [rw] adapter
      #   @return [String] The adapter for the service.
      attr_accessor :adapter

      # @!attribute [rw] adapter_opts
      #   @return [String] Options to pass to the given adapter.
      attr_accessor :adapter_opts

    end
  end
end