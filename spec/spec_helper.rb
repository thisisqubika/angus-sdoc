PROJECT_ROOT = File.expand_path(File.dirname(File.expand_path(__FILE__)) + "/..")

require 'bundler/setup'
require 'picasso/sdoc'

require 'rspec'

require 'simplecov'
SimpleCov.start

require 'simplecov-rcov'
require 'simplecov-rcov-text'

class SimpleCov::Formatter::MergedFormatter
  def format(result)
    SimpleCov::Formatter::RcovFormatter.new.format(result)
    SimpleCov::Formatter::RcovTextFormatter.new.format(result)
    SimpleCov::Formatter::HTMLFormatter.new.format(result)
  end
end
SimpleCov.formatter = SimpleCov::Formatter::MergedFormatter

Dir["#{PROJECT_ROOT}/spec/support/**/*.rb"].each { |f| require f }

RSpec.configure do |config|

end