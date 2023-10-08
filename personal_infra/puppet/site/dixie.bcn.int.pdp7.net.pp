node 'dixie.bcn.int.pdp7.net' {
  class {'dns_dhcp':}
  file {'/etc/dnsmasq.d/static.conf':
    content => "host-record=router,router.bcn.int.pdp7.net,192.168.76.1
host-record=archerc7,archerc7.bcn.int.pdp7.net,192.168.76.6
host-record=dixie.bcn.int.pdp7.net,dixie,192.168.76.2
dhcp-option=121,10.0.0.0/8,192.168.76.2
",
    notify => Service["dnsmasq"],
  }

  class {'backups':
    sanoid_config => "",
  }
}
