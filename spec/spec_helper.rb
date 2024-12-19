require 'bundler/setup'

require 'simplecov'
SimpleCov.start

require 'angus/sdoc'

require 'rspec'
require 'rspec/its'
require 'json_expressions/rspec'
require 'factory_bot'

require 'simplecov-rcov'
require 'simplecov-rcov-text'

SimpleCov.formatter = SimpleCov::Formatter::MultiFormatter.new([
  SimpleCov::Formatter::HTMLFormatter,
  SimpleCov::Formatter::RcovFormatter,
  SimpleCov::Formatter::RcovTextFormatter
])

Dir[File.join(File.dirname(__FILE__), 'support', '**', '*.rb')].each { |f| require f }

RSpec.configure do |config|

  # Run specs in random order to surface order dependencies. If you find an
  # order dependency and want to debug it, you can fix the order by providing
  # the seed, which is printed after each run.
  #     --seed 1234
  config.order = 'random'

  config.before(:suite) do
    FactoryBot.find_definitions
  end

end
