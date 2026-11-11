# Configuración de SimpleCov (estándar Bancard). La carga `require "simplecov"`,
# que es la primera línea de spec/spec_helper.rb.
#
# El coverage lo publica bancardsa/coverage-action en la CI (commit status y
# comentario de PR).

# Piso de cobertura del repo. Lo exige la action, no SimpleCov, y solo cuando
# COVERAGE_ENFORCE=true (variable de este repo). No llamar a
# SimpleCov.minimum_coverage: si los tests fallan por coverage, la action no
# publica la medición.
MINIMUM_COVERAGE = 85.0

require "simplecov_json_formatter"

SimpleCov.start do
  # JRuby no tiene branch coverage.
  enable_coverage :branch if RUBY_ENGINE == "ruby"

  add_filter "/config/"
  add_filter "/db/"
  add_filter "/log/"
  add_filter "/spec/"
  add_filter ".simplecov"

  command_name "rspec"

  formatter SimpleCov::Formatter::MultiFormatter.new([
                                                       SimpleCov::Formatter::HTMLFormatter,
                                                       SimpleCov::Formatter::JSONFormatter
                                                     ])
end
