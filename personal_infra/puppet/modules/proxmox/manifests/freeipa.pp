class proxmox::freeipa {
  class {'proxmox':}

  file {['/etc/subuid', '/etc/subgid']:
    content => epp('proxmox/freeipa_subxid', {'freeipa' => lookup('freeipa')}),
  }
}
