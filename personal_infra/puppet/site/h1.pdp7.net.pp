node 'h1.pdp7.net' {
  class {'proxmox::freeipa':}
  class {'proxmox::proxy':
    mail => lookup('mail.root_mail'),
    base_hostname => lookup('network.public_hostname'),
  }
  class {'dns_dhcp':}

  # TODO: ugly; tinc scripts require this :(
  package {'net-tools':}
}
