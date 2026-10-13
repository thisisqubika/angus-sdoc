require 'bundler/setup'

require 'simplecov'

SimpleCov.start do
  add_filter '/config/'
  add_filter '/db/'
  add_filter '/log/'
  add_filter '/spec/'
  add_filter '.simplecov'
end

require 'angus/sdoc'

require 'rspec'
require 'rspec/its'
require 'json_expressions/rspec'
# JRuby 9.4.1.0 only defines Fiber.current after require 'fiber'; i18n 1.15 (via factory_bot -> activesupport) calls it.
require 'fiber'
require 'factory_bot'

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
