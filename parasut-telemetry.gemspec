lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'parasut/telemetry/version'

Gem::Specification.new do |spec|
  spec.required_ruby_version = '>= 2.6'
  spec.name          = 'parasut-telemetry'
  spec.version       = Parasut::Telemetry::VERSION
  spec.authors       = ['Parasut']
  spec.email         = ['iletisim@parasut.com']

  spec.summary       = 'OpenTelemetry setup for Parasut Ruby services'
  spec.description   = 'Configures OpenTelemetry tracing (OTLP exporter + auto instrumentation) with a single call'
  spec.homepage      = 'https://www.github.com/parasutcom/parasut-telemetry'

  spec.files         = Dir['lib/**/*.rb', 'README.md']
  spec.require_paths = ['lib']

  # Geniş aralık bilerek: Bundler, Ruby 2.6'da 2023 sürümlerini (sdk 1.2.x,
  # exporter 0.24.x, instrumentation-all 0.33.x), Ruby 3.x'te güncellerini seçer.
  spec.add_runtime_dependency 'opentelemetry-sdk', '~> 1.2'
  spec.add_runtime_dependency 'opentelemetry-exporter-otlp', '>= 0.24', '< 1'
  spec.add_runtime_dependency 'opentelemetry-instrumentation-all', '>= 0.33', '< 1'

  spec.add_development_dependency 'minitest', '~> 5.0'
  spec.add_development_dependency 'rake', '>= 10'
end
