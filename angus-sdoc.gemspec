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
  spec.summary       = 'Read documentation of services built on angus'
  spec.homepage      = 'http://www.moove-it.com/angus'
  spec.license       = 'MIT'

  spec.files         = Dir.glob('{lib}/**/*')
  spec.test_files    = spec.files.grep(%r{^(spec)/})
  spec.require_paths = %w[lib]

  spec.add_development_dependency('rake')
  spec.add_development_dependency('yard', '0.8.7')
  spec.add_development_dependency('rspec', '~> 2.12')
  spec.add_development_dependency('factory_girl')
  spec.add_development_dependency('json_expressions')
  spec.add_development_dependency('simplecov', '0.7.1')
  spec.add_development_dependency('simplecov-rcov', '0.2.3')
  spec.add_development_dependency('simplecov-rcov-text', '0.0.2')
  spec.add_development_dependency('ci_reporter')
end