class dns_dhcp {
  $domain = lookup("'$ansible_inventory_hostname'.network.dns_dhcp.domain")

  package {'dnsmasq':}
  ->
  file {'/etc/dnsmasq.d/internal':
    content => epp('dns_dhcp/internal', {
      'dns_dhcp' => lookup("'$ansible_inventory_hostname'.network.dns_dhcp"),
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
