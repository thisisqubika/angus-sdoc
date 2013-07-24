# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'picasso/sdoc/version'

Gem::Specification.new do |spec|
  spec.name          = 'picasso-sdoc'
  spec.version       = Picasso::SDoc::VERSION
  spec.authors       = ['Pablo Ifran']
  spec.email         = ['pabloifran@gmail.com']
  spec.description   = %q{TODO: Write a gem description}
  spec.summary       = %q{TODO: Write a gem summary}
  spec.homepage      = ''
  spec.license       = 'MIT'

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ['lib']

  spec.add_development_dependency('bundler', '~> 1.3')
  spec.add_development_dependency('rake')

  # Testing
  spec.add_development_dependency('rspec', '~> 2.12')
  spec.add_development_dependency('faker')
  spec.add_development_dependency('simplecov', '0.7.1')
  spec.add_development_dependency('simplecov-rcov', '0.2.3')
  spec.add_development_dependency('simplecov-rcov-text', '0.0.2')
  spec.add_development_dependency('ci_reporter')
end
