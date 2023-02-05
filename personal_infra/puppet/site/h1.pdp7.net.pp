node 'h1.pdp7.net' {
  class {'proxmox::freeipa':}
  class {'dns_dhcp':}

  # TODO: ugly; tinc scripts require this :(
  package {'net-tools':}
}
