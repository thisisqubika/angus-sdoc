module JsonRepresentations
  module ProxyOperations

    def proxy_operation_representation(proxy_operation)
      {
        :path => proxy_operation.path,
        :method => proxy_operation.method,
        :service => proxy_operation.service_name,
        :adapter => proxy_operation.adapter,
        :adapter_opts => proxy_operation.adapter_opts
      }
    end

  end
end