# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'picasso/sdoc/version'

Gem::Specification.new do |spec|
  spec.name          = 'picaussso-sdoc'
  spec.version       = Picasso::SDoc::VERSION
  spec.authors       = ['Pablo Ifran', 'Adrian Gomez', 'Gianfranco Zas']
  spec.email         = %w[picasso@moove-it.com]
  spec.description   = 'Read the documentation of the services and generate html based on that documentation'
  spec.summary       = 'Read the documentation of the services'
  spec.homepage      = ''
  spec.license       = 'MIT'

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = %w[lib]

  spec.add_development_dependency('bundler', '~> 1.3')
  spec.add_development_dependency('rake')
  spec.add_development_dependency('yard', '0.8.7')

  # Testing
  spec.add_development_dependency('rspec', '~> 2.12')
  spec.add_development_dependency('factory_girl')
  spec.add_development_dependency('json_expressions')
  spec.add_development_dependency('simplecov', '0.7.1')
  spec.add_development_dependency('simplecov-rcov', '0.2.3')
  spec.add_development_dependency('simplecov-rcov-text', '0.0.2')
  spec.add_development_dependency('ci_reporter')
end
