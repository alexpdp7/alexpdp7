class dns_dhcp::opennic {
  Package['dnsmasq']
  ->
  file {'/etc/dnsmasq.d/opennic':
    content => @(EOT)
    server=/bbs/chan/cyb/dyn/geek/gopher/indy/libre/neo/null/o/oss/oz/parody/pirate/fur/94.247.43.254
    server=/bbs/chan/cyb/dyn/geek/gopher/indy/libre/neo/null/o/oss/oz/parody/pirate/fur/152.53.15.127
    | EOT
    ,
  }
  ~>
  Service['dnsmasq']
}
