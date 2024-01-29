node 'ipsilon.h1.int.pdp7.net' {
  class {'ipsilon':
    session_timeout_minutes => 60*24*7,
  }

  service {'nagios':}
  package {'nagios':
    ensure => absent,
  }

  nagios_service {'idp.pdp7.net-internal-cert':
    use => 'generic-service',
    service_description => 'idp.pdp7.net-internal-cert',
    host_name => 'ipsilon.h1.int.pdp7.net',
    check_command => 'check_idp.pdp7.net-internal-cert',
    require => Package['nagios'],
    notify => Service['nagios'],
    owner => 'nagios',
  }

  nagios_command {'check_idp.pdp7.net-internal-cert':
    command_name => 'check_idp.pdp7.net-internal-cert',
    command_line => '/usr/lib64/nagios/plugins/check_http -H idp.pdp7.net -I ipsilon.h1.int.pdp7.net -C 10,5 -p 443',
    require => Package['nagios'],
    notify => Service['nagios'],
    owner => 'nagios',
  }
}
