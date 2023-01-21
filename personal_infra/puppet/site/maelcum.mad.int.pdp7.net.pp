node 'maelcum.mad.int.pdp7.net' {
  class {'dns_dhcp':}
  class {'freeipa::dnsmasq':}
  file {'/etc/dnsmasq.d/static.conf':
    content => 'host-record=router,router.mad.int.pdp7.net,10.34.10.1
dhcp-host=d8:8c:79:1a:11:59,chromecast,10.34.10.3
host-record=maelcum.mad.int.pdp7.net,maelcum,10.34.10.2
',
    notify => Service['dnsmasq'],
  }
}
