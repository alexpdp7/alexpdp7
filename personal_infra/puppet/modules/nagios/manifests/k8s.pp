class nagios::k8s {
  nagios_command {'check_talos':
    command_name => 'check_talos',
    command_line => '/usr/lib64/nagios/plugins/check_http -H monitor -I $HOSTADDRESS$ -s OK -u /available',
    require => Package['nagios'],
    notify => Service['nagios'],
    owner => 'nagios',
  }

  nagios_hostgroup {'k8s':
    hostgroup_name => 'k8s',
    require => Package['nagios'],
    notify => Service['nagios'],
    owner => 'nagios',
    ensure => present,
  }

  nagios_servicegroup {'talos_check':
    require => Package['nagios'],
    notify => Service['nagios'],
    owner => 'nagios',
    ensure => present,
  }

  nagios_service {'talos-check':
    use => 'generic-service',
    hostgroup_name => 'k8s',
    service_description => 'check_talos',
    servicegroups => 'talos_check',
    check_command => 'check_talos',
    require => Package['nagios'],
    notify => Service['nagios'],
    owner => 'nagios',
  }
}
