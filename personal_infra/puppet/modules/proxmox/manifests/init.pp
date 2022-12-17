class proxmox {
  file {'/etc/network/interfaces':
    content => epp('proxmox/interfaces', {
      "network" => lookup("'$ansible_inventory_hostname'.network"),
    }),
  }
  ~>
  exec {'/usr/sbin/ifreload -a':
    refreshonly => true
  }

  # to prevent Germany/Hetzner abuse complaints
  service {['rpcbind.target', 'rpcbind.service', 'rpcbind.socket']:
    ensure => stopped,
    enable => mask,
  }

  # TODO: secure this. Right now I don't use VMs, so just disable it
  service {'spiceproxy':
    ensure => stopped,
    enable => mask,
  }

}
