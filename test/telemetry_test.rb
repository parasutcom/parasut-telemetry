require 'minitest/autorun'
require 'parasut/telemetry'

class TelemetryTest < Minitest::Test
  def setup
    ENV['OTEL_TRACES_EXPORTER'] = 'none'
    ENV.delete('OTEL_SERVICE_NAME')
  end

  def test_disabled_by_default
    ENV.delete('OTEL_ENABLED')
    refute Parasut::Telemetry.configure(service_name: 'test-app')
  end

  # Ayrı süreçte: diğer test aynı süreçte OTel'i zaten yüklemiş olabilir.
  def test_disabled_does_not_load_opentelemetry
    lib = File.expand_path('../lib', __dir__)
    out = `#{RbConfig.ruby} -I#{lib} -rparasut/telemetry -e 'Parasut::Telemetry.configure(service_name: "x"); print defined?(OpenTelemetry).inspect'`
    assert_equal 'nil', out
  end

  def test_configures_service_name_and_instrumentation
    assert Parasut::Telemetry.configure(service_name: 'test-app', enabled: true)

    provider = OpenTelemetry.tracer_provider
    assert_kind_of OpenTelemetry::SDK::Trace::TracerProvider, provider
    attrs = provider.instance_variable_get(:@resource).attribute_enumerator.to_h
    assert_equal 'test-app', attrs['service.name']

    span = OpenTelemetry.tracer_provider.tracer('t').start_span('s')
    assert span.context.valid?
    span.finish
  end
end
