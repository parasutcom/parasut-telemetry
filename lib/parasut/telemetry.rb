require 'parasut/telemetry/version'

module Parasut
  module Telemetry
    # Exporter, endpoint, sampler ve resource ayarları standart OTEL_* env
    # değişkenlerinden okunur (OTEL_EXPORTER_OTLP_ENDPOINT vb.), bkz. README.
    def self.configure(service_name:, enabled: ENV['OTEL_ENABLED'] == 'true', instrumentation: {})
      return false unless enabled

      # Kapalıyken OTel ve ~50 instrumentation gem'i hiç yüklenmesin diye burada.
      require 'opentelemetry/sdk'
      require 'opentelemetry/exporter/otlp'
      require 'opentelemetry/instrumentation/all'

      OpenTelemetry::SDK.configure do |c|
        c.service_name = ENV.fetch('OTEL_SERVICE_NAME', service_name)
        c.service_version = ENV['OTEL_SERVICE_VERSION'] if ENV['OTEL_SERVICE_VERSION']
        c.use_all(instrumentation)
      end
      true
    end
  end
end
