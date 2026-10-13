lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)

require 'angus/sdoc/version'

Gem::Specification.new do |spec|
  spec.name          = 'angus-sdoc'
  spec.version       = Angus::SDoc::VERSION
  spec.authors       = ['Pablo Ifran', 'Adrian Gomez', 'Gianfranco Zas', 'Manuel Pacheco']
  spec.email         = %w[angus@qubika.com]
  spec.description   = <<-DESCRIPTION
    Used to read the documentation of a service built in angus (but also is able to read any kind
    of documentation that follow the angus structure), and generate an object representation of
    that documentation.
  DESCRIPTION
  spec.summary       = 'Expose service API documentation.'
  spec.homepage      = 'https://github.com/thisisqubika/angus-sdoc'
  spec.license       = 'MIT'
  spec.required_ruby_version = '>= 2.5'

  spec.files         = Dir.glob('{lib}/**/*')
  spec.require_paths = %w[lib]

  spec.add_development_dependency('rake')
  spec.add_development_dependency('yard')
  spec.add_development_dependency('rspec')
  spec.add_development_dependency('rspec-its')
  spec.add_development_dependency('factory_bot', '!= 6.4.5')
  spec.add_development_dependency('json_expressions')
  spec.add_development_dependency('simplecov')
end
