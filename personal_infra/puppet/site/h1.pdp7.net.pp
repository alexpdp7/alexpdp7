node 'h1.pdp7.net' {
  class {'proxmox::freeipa':}
  class {'dns_dhcp':}

  # TODO: ugly; tinc scripts require this :(
  package {'net-tools':}

  class {'proxmox::proxy':
    mail => lookup('mail.root_mail'),
    base_hostname => lookup('network.public_hostname'),
  }

  proxmox::proxy_host {'ipsilon-test.pdp7.net':
    target => 'ipsilon-test.h1.int.pdp7.net',
  }
}
