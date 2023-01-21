node 'ovh1.pdp7.net' {
  class {'dns_dhcp':}
  class {'freeipa::dnsmasq':}
}
