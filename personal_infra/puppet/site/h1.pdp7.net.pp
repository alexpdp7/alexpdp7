node 'h1.pdp7.net' {
  class {'proxmox':}
  class {'dns_dhcp':}
  class {'freeipa::dnsmasq':}

  # TODO: ugly; tinc scripts require this :(
  package {'net-tools':}
}
