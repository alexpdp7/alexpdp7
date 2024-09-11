class dns_dhcp {
  $domain = lookup('network.dns_dhcp.domain')

  $hostvars = lookup('hostvars')
  $fixed_dhcp_host_vars = $hostvars.filter |$host, $vars| { $vars['network'] and $vars['network']['dhcp_server'] == $facts["networking"]["fqdn"] }
  $fixed_dhcp_hosts = Hash($fixed_dhcp_host_vars.map |$host, $vars| { [$host.match(/^[-a-z0-9]+/)[0], $vars['network']['ip'] ] })

  $fixed_host_vars = $hostvars.filter |$host, $vars| { $vars['network'] and $vars['network']['register_dns_server'] == $facts["networking"]["fqdn"] }
  $fixed_hosts = Hash($fixed_host_vars.map |$host, $vars| { [$host.match(/^[-a-z0-9]+/)[0], $vars['network']['ip'] ] })

  package {'dnsmasq':}
  ->
  file {'/etc/dnsmasq.d':
    ensure => directory,
    purge => true,
    recurse => true,
  }
  ->
  file {'/etc/dnsmasq.d/internal':
    content => epp('dns_dhcp/internal', {
      'dns_dhcp' => lookup("network.dns_dhcp"),
      'dns_other_server_defs' => $dns_other_server_defs,
      'fixed_dhcp_hosts' => $fixed_dhcp_hosts,
      'fixed_hosts' => $fixed_hosts,
    }),
  }
  ~>
  service {'dnsmasq':
    enable => true,
    ensure => running,
  }
  ->
  file {'/etc/resolv.conf':
    content => "domain ${domain}\nsearch ${domain}\nnameserver 127.0.0.1\n",
  }

  $k8s_hosts = lookup('groups.k8s')
  $k8s_hosts.each |String $k8s_host| {
    $cluster_name = lookup("hostvars.'$k8s_host'.talos_host.talos_cluster")
    $ip = lookup("hostvars.'$k8s_host'.network.ip")
    file {"/etc/dnsmasq.d/$k8s_host":
      content => @("EOT")
      address=/${cluster_name}.int.pdp7.net/$ip
      | EOT
      ,
      require => File['/etc/dnsmasq.d'],
      notify => Service['dnsmasq'],
    }
  }
}
