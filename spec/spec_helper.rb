PROJECT_ROOT = File.expand_path(File.dirname(File.expand_path(__FILE__)) + '/..')

require 'bundler/setup'

require 'simplecov'
SimpleCov.start

require 'picasso/sdoc'

require 'rspec'

require 'simplecov-rcov'
require 'simplecov-rcov-text'

SimpleCov.formatter = SimpleCov::Formatter::MultiFormatter[
  SimpleCov::Formatter::HTMLFormatter,
  SimpleCov::Formatter::RcovFormatter,
  SimpleCov::Formatter::RcovTextFormatter
]

Dir["#{PROJECT_ROOT}/spec/support/**/*.rb"].each { |f| require f }

RSpec.configure do |config|

end