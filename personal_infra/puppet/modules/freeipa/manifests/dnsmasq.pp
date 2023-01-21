class freeipa::dnsmasq {
  $services = [
    {'service' => '_kerberos-master', 'protocol' => '_tcp', 'port' => '88'},
    {'service' => '_kerberos-master', 'protocol' => '_udp', 'port' => '88'},
    {'service' => '_kerberos', 'protocol' => '_tcp', 'port' => '88'},
    {'service' => '_kerberos', 'protocol' => '_udp', 'port' => '88'},
    {'service' => '_kpasswd', 'protocol' => '_tcp', 'port' => '464'},
    {'service' => '_kpasswd', 'protocol' => '_udp', 'port' => '464'},
    {'service' => '_ldap', 'protocol' => '_tcp', 'port' => '389'},
  ]

  file {'/etc/dnsmasq.d/ipa':
    notify => Service['dnsmasq'],
    content => epp('freeipa/dnsmasq', {'services' => $services,
                                       'freeipa' => lookup("freeipa"),
                                      }),
  }
}
