node 'clickhouse.h1.int.pdp7.net' {
  class {'clickhouse':}

  class {'otel':
    version => '0.88.0',
  }

  file {'/etc/otelcol-contrib/config.yaml':
    content => @(EOT)
      receivers:
        otlp:
          protocols:
            grpc:
            http:
              cors:
                allowed_origins:
                  - "http://*"
                  - "https://*"
      processors:
        batch:
          timeout: 5s
          send_batch_size: 100000
      exporters:
        clickhouse:
          endpoint: tcp://127.0.0.1:9000?dial_timeout=10s&compress=lz4
          database: otel
          ttl_days: 180
          logs_table_name: otel_logs
          traces_table_name: otel_traces
          metrics_table_name: otel_metrics
          timeout: 5s
          retry_on_failure:
            enabled: true
            initial_interval: 5s
            max_interval: 30s
            max_elapsed_time: 300s
      service:
        pipelines:
          logs:
            receivers: [ otlp ]
            processors: [ batch ]
            exporters: [ clickhouse ]
          metrics:
            receivers: [ otlp ]
            processors: [ batch ]
            exporters: [ clickhouse ]
          traces:
            receivers: [ otlp ]
            processors: [ batch ]
            exporters: [ clickhouse ]
      | EOT
    ,
    require => Package['otelcol-contrib'],
    notify => Service['otelcol-contrib'],
  }

  Package['otelcol-contrib']
  ->
  file {'/etc/systemd/system/otelcol-contrib.service.d':
    ensure => directory,
  }
  ->
  Package['clickhouse-server']
  ->
  file {'/etc/systemd/system/otelcol-contrib.service.d/depends.conf':
    content => @(EOT)
    [Unit]
    Requires=clickhouse-server.service
    | EOT
    ,
  }
  ~>
  exec {'/usr/bin/systemctl daemon-reload':}
  ~>
  Service['otelcol-contrib']
}
