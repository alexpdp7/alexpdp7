node 'nagios.h1.int.pdp7.net' {
  class {'nagios':}
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
}
