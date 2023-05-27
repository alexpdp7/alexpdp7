class nagios::k8s {
  file {'/usr/local/bin/check_talos_version':
    content => file('nagios/check_talos_version'),
    mode => '0755',
    links => follow,
  }

  nagios_command {'check_talos':
    command_name => 'check_talos',
    command_line => '/usr/local/bin/check_talos_version http://$HOSTADDRESS$ monitor',
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
