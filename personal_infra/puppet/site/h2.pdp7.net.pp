node 'h2.pdp7.net' {
  class {'dns_dhcp':}
  class {'freeipa::dnsmasq':}

  file {'/etc/dnsmasq.d/static.conf':
    content => "dhcp-host=freeswitch,10.42.42.3,freeswitch
host-record=h2.h2.int.pdp7.net,10.42.42.1
",
  }    
}
