# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'angus/sdoc/version'

Gem::Specification.new do |spec|
  spec.name          = 'angus-sdoc'
  spec.version       = Angus::SDoc::VERSION
  spec.authors       = ['Pablo Ifran', 'Adrian Gomez', 'Gianfranco Zas']
  spec.email         = %w[angus@moove-it.com]
  spec.description   = <<-DESCRIPTION
    Used to read the documentation of a service built in angus (but also is able to read any kind
    of documentation that follow the angus structure), and generate an object representation of
    that documentation.
  DESCRIPTION
  spec.summary       = 'Expose service API documentation.'
  spec.homepage      = 'https://github.com/Moove-it/angus-sdoc'
  spec.license       = 'MIT'

  spec.files         = Dir.glob('{lib}/**/*')
  spec.test_files    = spec.files.grep(%r{^(spec)/})
  spec.require_paths = %w[lib]

  spec.add_development_dependency('rake')
  spec.add_development_dependency('yard')
  spec.add_development_dependency('rspec')
  spec.add_development_dependency('rspec-its')
  spec.add_development_dependency('factory_bot', '!= 6.4.5')
  spec.add_development_dependency('json_expressions')
  spec.add_development_dependency('simplecov')
  spec.add_development_dependency('simplecov-rcov')
  spec.add_development_dependency('simplecov-rcov-text')
  spec.add_development_dependency('ci_reporter')
end
