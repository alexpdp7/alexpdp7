class otel($version) {
  package {'otel-contrib':
    source => "https://github.com/open-telemetry/opentelemetry-collector-releases/releases/download/v${version}/otelcol-contrib_${version}_linux_386.rpm",
  }
  ->
  service {'otelcol-contrib':
    ensure => running,
    enable => true,
  }
}
