include automatic_updates
include basic_software
include root_mail

if $facts['os']['family'] == 'Debian' {
  class {'debian':}
}

$nagios_host = $facts['networking']['fqdn']

nagios_host {$nagios_host:
  use => 'generic-host',
  address => lookup({name => 'nagios.address', default_value => $facts['networking']['fqdn']}),
  max_check_attempts => 5,
  contact_groups => "admins",
  check_command => "check-host-alive",
}

nagios_service {"${nagios_host}-ssh":
  use => 'generic-service',
  host_name => $facts['networking']['fqdn'],
  service_description => "ssh",
  check_command => "check_ssh",
}
