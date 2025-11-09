include automatic_updates
include basic_software
include root_mail

if $facts['os']['family'] == 'Debian' {
  class {'debian':}
}

if lookup({name => 'nagios.monitor', default_value => true}) {
  $nagios_host = $facts['networking']['fqdn']

  nagios_host {$nagios_host:
    use => 'generic-host',
    address => lookup({name => 'nagios.address', default_value => $facts['networking']['fqdn']}),
    max_check_attempts => 5,
    contact_groups => 'admins',
    hostgroups => 'linux',
    check_command => 'check-host-alive',
  }
}

# https://github.com/alexpdp7/ragent/issues/352
if $facts['os']['family'] == 'RedHat' and $facts['os']['release']['major'] == '9' {
  package {'compat-openssl11':}
}

if $facts['os']['family'] == 'RedHat' and $facts['os']['release']['major'] == "10" {
  service {'dev-mqueue.mount':
    ensure => stopped,
    enable => mask,
  }
  ~>
  Exec['/usr/bin/systemctl reset-failed']
}
