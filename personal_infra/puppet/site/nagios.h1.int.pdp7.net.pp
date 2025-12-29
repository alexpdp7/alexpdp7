node 'nagios.h1.int.pdp7.net' {
  class {'nagios':
    otel_host => 'clickhouse.h1.int.pdp7.net',
  }
  class {'nagios::k8s':}

  $k8s_hosts = lookup("groups.k8s")

  $k8s_hosts.each |String $k8s_host| {
    nagios_host {$k8s_host:
      use => 'generic-host',
      max_check_attempts => 5,
      contact_groups => 'admins',
      hostgroups => 'k8s',
      check_command => 'check-host-alive',
    }
  }

  nagios_host {"archerc7.bcn.int.pdp7.net":
    use => 'generic-host',
    max_check_attempts => 20,
    flap_detection_enabled => 0,
    contact_groups => 'admins',
    check_command => 'check-host-alive',
    parents => ["dixie.bcn.int.pdp7.net"],
    address => "192.168.76.6",
  }

  nagios_host {"router4g.bcn.int.pdp7.net":
    use => 'generic-host',
    max_check_attempts => 20,
    flap_detection_enabled => 0,
    contact_groups => 'admins',
    check_command => 'check-host-alive',
    parents => ["dixie.bcn.int.pdp7.net"],
    address => "192.168.76.3",
  }

  nagios_service {'alex.corcoles.net-gemini-cert':
    use => 'generic-service',
    service_description => 'alex.corcoles.net-gemini-cert',
    host_name => 'k8s-prod.h1.int.pdp7.net',
    check_command => 'check_alex.corcoles.net-gemini-cert',
    require => Package['nagios'],
    notify => Service['nagios'],
    owner => 'nagios',
  }

  nagios_command {'check_alex.corcoles.net-gemini-cert':
    command_name => 'check_alex.corcoles.net-gemini-cert',
    command_line => '/usr/lib64/nagios/plugins/check_http -H alex.corcoles.net -C 10,5 -p 1965',
    require => Package['nagios'],
    notify => Service['nagios'],
    owner => 'nagios',
  }

  package {'nagios-plugins-pgsql':}

  class {'otel':
    version => '0.88.0',
  }

  # TODO: add otelcol-contrib user to nagios group
  file {'/etc/otelcol-contrib/config.yaml':
    content => @("EOT")
      exporters:
        otlp:
          endpoint: clickhouse.h1.int.pdp7.net:4317
          tls:
            insecure: true

      receivers:
        filelog:
          include: [ /var/log/nagios/nagios.log ]
          operators:
            - type: regex_parser
              regex: '^\[(?P<time>\d+)\] (?P<log>.*)$'
              timestamp:
                parse_from: attributes.time
                layout_type: epoch
                layout: s

      processors:
        transform:
          log_statements:
            - context: log
              statements:
                - merge_maps(attributes, ExtractPatterns(attributes["log"], "^(?P<type>SERVICE NOTIFICATION):[ ](?P<contact>[^;]*);(?P<host>[^;]*);(?P<service>[^;]*);(?P<status>[^;]*);(?P<command>[^;]*);(?P<check_status_line>.*)$"), "insert") where IsMatch(attributes["log"], "^SERVICE NOTIFICATION:")
                - merge_maps(attributes, ExtractPatterns(attributes["log"], "^(?P<type>HOST NOTIFICATION):[ ](?P<contact>[^;]*);(?P<host>[^;]*);(?P<status>[^;]*);(?P<command>[^;]*);(?P<check_status_line>.*)$"), "insert") where IsMatch(attributes["log"], "^HOST NOTIFICATION:")

      service:
        pipelines:
          logs:
            receivers: [filelog]
            processors: [transform]
            exporters: [otlp]
      | EOT
    ,
    require => Package['otelcol-contrib'],
    notify => Service['otelcol-contrib'],
  }
}
