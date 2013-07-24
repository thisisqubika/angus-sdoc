PROJECT_ROOT = File.expand_path(File.dirname(File.expand_path(__FILE__)) + '/..')

require 'bundler/setup'

require 'simplecov'
SimpleCov.start

require 'picasso/sdoc'

require 'rspec'
require 'faker'

require 'simplecov-rcov'
require 'simplecov-rcov-text'

SimpleCov.formatter = SimpleCov::Formatter::MultiFormatter[
  SimpleCov::Formatter::HTMLFormatter,
  SimpleCov::Formatter::RcovFormatter,
  SimpleCov::Formatter::RcovTextFormatter
]

Dir["#{PROJECT_ROOT}/spec/support/**/*.rb"].each { |f| require f }

RSpec.configure do |config|

  # Run specs in random order to surface order dependencies. If you find an
  # order dependency and want to debug it, you can fix the order by providing
  # the seed, which is printed after each run.
  #     --seed 1234
  config.order = 'random'
end