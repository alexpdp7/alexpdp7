class dns_dhcp {
  $domain = lookup("network.dns_dhcp.domain")

  package {'dnsmasq':}
  ->
  file {'/etc/dnsmasq.d/internal':
    content => epp('dns_dhcp/internal', {
      'dns_dhcp' => lookup("network.dns_dhcp"),
      'dns_other_server_defs' => $dns_other_server_defs,
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
}
