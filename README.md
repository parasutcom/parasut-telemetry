# parasut-telemetry

Paraşüt Ruby servislerine OpenTelemetry trace desteğini tek satırla ekler:
SDK, OTLP exporter ve otomatik instrumentation (Rails/Rack, ActiveRecord, PG,
Sidekiq, Net::HTTP, Faraday, Redis, …) birlikte kurulur.

`OTEL_ENABLED=true` verilmedikçe hiçbir şey yapmaz, OpenTelemetry gem'lerini
yüklemez bile. Gem'i önce kurup sonra env ile açabilirsin.

## Kurulum

`Gemfile`:

```ruby
source 'https://<token>@gem.fury.io/parasut/'
gem 'parasut-telemetry', '0.1.0'
```

`config/initializers/opentelemetry.rb`:

```ruby
Parasut::Telemetry.configure(service_name: 'parasut-<servis>')
```

Rails dışındaki bir Ruby süreçte, uygulama kodu yüklendikten sonra aynı çağrıyı yap.

İstemediğin bir instrumentation'ı kapatmak ya da ayarını değiştirmek için:

```ruby
Parasut::Telemetry.configure(
  service_name: 'parasut-server',
  instrumentation: {
    'OpenTelemetry::Instrumentation::Redis' => { enabled: false }
  }
)
```

## Ortam değişkenleri

| Değişken | Örnek | Not |
|---|---|---|
| `OTEL_ENABLED` | `true` | Gem'e ait anahtar; yoksa kapalıdır |
| `OTEL_EXPORTER_OTLP_ENDPOINT` | `http://otel-collector:4318` | OTLP/HTTP; varsayılanı `http://localhost:4318` |
| `OTEL_SERVICE_NAME` | `parasut-server` | Verilirse koddaki `service_name`'i ezer |
| `OTEL_SERVICE_VERSION` | git sha | İsteğe bağlı |
| `OTEL_RESOURCE_ATTRIBUTES` | `deployment.environment=production` | Ek resource alanları |
| `OTEL_TRACES_SAMPLER` / `OTEL_TRACES_SAMPLER_ARG` | `parentbased_traceidratio` / `0.1` | Örnekleme |
| `OTEL_EXPORTER_OTLP_HEADERS` | `authorization=Bearer …` | Collector kimlik doğrulama istiyorsa |

Geri kalan her şey standart OpenTelemetry env değişkenleriyle ayarlanır.

## Ruby sürümleri

Gem `>= 2.6` destekler. OTel bağımlılıkları geniş aralıkla verildiği için
Bundler, Ruby sürümüne uyan en yeni OTel'i seçer:

- Ruby 2.6 / 2.7 → sdk 1.2.x, exporter-otlp 0.24.x, instrumentation-all 0.33.x (2023 sürümleri, artık güncelleme almıyor)
- Ruby 3.x → güncel sürümler

Ruby'yi yükselten servis `bundle update opentelemetry-sdk opentelemetry-exporter-otlp opentelemetry-instrumentation-all` ile güncel OTel'e geçer.

## Fork'lanan sunucular

Puma'nın `preload_app!` ile çalışan worker'ları ve Sidekiq için ek ayar gerekmez:
`BatchSpanProcessor` fork sonrasında export thread'ini kendisi yeniden başlatır.

## Kapsam dışı

- **Metrics:** Ruby OTel metrics SDK deneysel, Ruby 2.6'da yok. server'da metrik için yabeda var.
- **Logs:** log korelasyonu (trace_id'yi lograge'a eklemek) sonraki adım.

## Geliştirme

```sh
bundle install
bundle exec rake test
```

Yayınlamak için: `VERSION`'ı artır, `gem build parasut-telemetry.gemspec`, ardından gemfury'ye push et.
