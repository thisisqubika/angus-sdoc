require 'erb'

module Angus
  module SDoc
    class HtmlFormatter

      class << self

        # Generates the html for the service definition.
        #
        # @param [Angus::SDoc::Definitions::Service] service_definition the service definition.
        #
        # @return [String] the generated html.
        def format_service(service_definition)
          @service = service_definition

          erb(:doc)
        end

        private

        def erb(template)
          template = File.open(File.join(templates_path, "#{template}.erb")).read
          ERB.new(template).result(binding)
        end

        def h_type(type, service)
          if service.representations_hash.include?(type)
            "<a href='#representation-#{service.representations_hash[type].name}'>#{type}</a>"
          else
            type
          end
        end

        def templates_path
          File.join(File.dirname(__FILE__), 'templates')
        end
      end

    end
  end
end