require_relative 'glossaries'
require_relative 'operations'
require_relative 'representations'
require_relative 'messages'
require_relative 'proxy_operations'

module JsonRepresentations
  module Services
    include Operations
    include ProxyOperations
    include Representations
    include Messages
    include Glossaries

    def service_representation(service)
      operations = service.operations.inject({}) do |result, operation|
        result.merge({operation.code_name => operation_representation(operation)})
      end

      proxy_operations = service.proxy_operations.inject({}) do |result, proxy_operation|
        result.merge({proxy_operation.code_name => proxy_operation_representation(proxy_operation)})
      end

      representations = service.representations.inject({}) do |result, representation|
        result.merge({representation.name => representation_representation(representation)})
      end

      {
        :service => {
          :service => service.name,
          :code_name => service.code_name,
          :version => service.version
        },
        :operations => operations,
        :proxy_operations => proxy_operations,
        :representations => representations,
        :messages => service.messages.map { |key, message| message_representation(message) },
        :glossary => glossary_representation(service.glossary)
      }
    end

  end
end