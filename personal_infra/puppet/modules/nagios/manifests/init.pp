class nagios {
  package {'nagios':}
  ->
  service {'nagios':
    ensure => running,
    enable => true,
  }

  file {
    default:
      require => Package['nagios'],
      notify => Service['nagios'],
      ;
    '/etc/nagios':
      ensure => directory,
      recurse => true,
      force => true,
      purge => true,
      ;
    '/etc/nagios/nagios.cfg':
      content => epp('nagios/nagios.cfg'),
      ;
    # leave these unaffected
    ['/etc/nagios/passwd', '/etc/nagios/cgi.cfg', '/etc/nagios/private/resource.cfg', '/etc/nagios/objects', '/etc/nagios/private', '/etc/nagios/objects/commands.cfg', '/etc/nagios/objects/timeperiods.cfg', '/etc/nagios/objects/templates.cfg']:
      ensure => present,
      ;
  }

  nagios_contact {'nagiosadmin':
    use => 'generic-contact',
    email => lookup('mail.root_mail'),
    require => Package['nagios'],
    notify => Service['nagios'],
    owner => 'nagios',
  }

  nagios_contactgroup {'admins':
    members => 'nagiosadmin',
    require => Package['nagios'],
    notify => Service['nagios'],
    owner => 'nagios',
  }

  nagios_command {'check_ragent':
    command_name => 'check_ragent',
    command_line => '/usr/bin/check_ragent http://$HOSTADDRESS$:21488/ --warning-units dnf-makecache.service --warning-units dnf-automatic-install.service',
    require => Package['nagios'],
    notify => Service['nagios'],
    owner => 'nagios',
  }

  nagios_hostgroup {'linux':
    hostgroup_name => 'linux',
    require => Package['nagios'],
    notify => Service['nagios'],
    owner => 'nagios',
    ensure => present,
  }

  nagios_servicegroup {'ragent':
    require => Package['nagios'],
    notify => Service['nagios'],
    owner => 'nagios',
    ensure => present,
  }

  nagios_service {'check_ragent':
    use => 'generic-service',
    hostgroup_name => 'linux',
    service_description => 'check_ragent',
    servicegroups => 'ragent',
    check_command => 'check_ragent',
    require => Package['nagios'],
    notify => Service['nagios'],
    owner => 'nagios',
  }

  nagios_service {'check_ssh':
    use => 'generic-service',
    hostgroup_name => 'linux',
    service_description => 'ssh',
    check_command => 'check_ssh',
    require => Package['nagios'],
    notify => Service['nagios'],
    owner => 'nagios',
  }

  package {'httpd':}
  ->
  service {'httpd':
    ensure => running,
    enable => true,
  }

  if $facts['virtual'] == 'lxc' {
    file {'/bin/ping':
      mode => 'u+s',
    }
  }
}
