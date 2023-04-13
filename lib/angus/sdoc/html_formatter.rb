require 'erb'

module Angus
  module SDoc
    class HtmlFormatter

      ENGLISH_LANG = 'en'

      # Generates the html for the service definition.
      #
      # @param [Angus::SDoc::Definitions::Service] service_definition the service definition.
      # @param [String] language The language to user for the documentation, defaults to english
      #
      # @return [String] the generated html.
      def self.format_service(service_definition, language = nil)
        @service = service_definition
        @language = language || ENGLISH_LANG

        erb(:doc, @language)
      end

      def self.erb(template, language = nil)
        template_name = if language
                          "#{template}.#{language}.erb"
                        else
                          "#{template}.erb"
                        end

        template = File.open(File.join(templates_path, template_name)).read
        ERB.new(template).result(binding)
      end
      private_class_method :erb

      def self.operation_path(operation)
        "/#{@service.code_name}/api/#{@service.version}#{operation.path}"
      end
      private_class_method :operation_path

      def self.h_type(type, service)
        if service.representations_hash.include?(type)
          "<a href='#representation-#{service.representations_hash[type].name}'>#{type}</a>"
        else
          type
        end
      end
      private_class_method :h_type

      def self.templates_path
        File.join(File.dirname(__FILE__), 'templates')
      end
      private_class_method :templates_path

    end
  end
end
