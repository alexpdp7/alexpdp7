node 'case.ces.int.pdp7.net' {
  class {'dns_dhcp':}
  ->
  file {'/etc/dnsmasq.d/static.conf':
    content => 'host-record=router,router.ces.int.pdp7.net,10.17.19.1
host-record=tplink,tplink.ces.int.pdp7.net,10.17.19.2
host-record=case.ces.int.pdp7.net,case,10.17.19.3
',
  }

  service {['sssd-pac.service', 'sssd-pac.socket']:
    ensure => stopped,
    enable => mask,
  }
}
