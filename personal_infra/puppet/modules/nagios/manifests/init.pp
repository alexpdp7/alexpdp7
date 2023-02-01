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
 
  package {'httpd':}
  ->
  service {'httpd':
    ensure => running,
    enable => true,
  }
}
