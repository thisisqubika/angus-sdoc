module JsonRepresentations
  module ProxyOperations

    def proxy_operation_representation(proxy_operation)
      {
        :path => proxy_operation.path,
        :method => proxy_operation.http_method,
        :service => proxy_operation.service_name
      }
    end

  end
end
