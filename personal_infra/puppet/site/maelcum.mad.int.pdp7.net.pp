node 'maelcum.mad.int.pdp7.net' {
  class {'dns_dhcp':}
  file {'/etc/dnsmasq.d/static.conf':
    content => @(EOT)
    host-record=router,router.mad.int.pdp7.net,10.34.10.1
    dhcp-host=d8:8c:79:1a:11:59,chromecast,10.34.10.3
    host-record=maelcum.mad.int.pdp7.net,maelcum,10.34.10.2

    dhcp-option=option:classless-static-route,192.168.76.0/24,10.34.10.2,10.43.43.0/24,10.34.10.2,10.17.19.0/24,10.34.10.2
    | EOT
    ,
    notify => Service['dnsmasq'],
  }

  service {'sssd-pam.socket':
    ensure => stopped,
    enable => mask,
  }
  ~>
  Exec['/usr/bin/systemctl reset-failed']
}
