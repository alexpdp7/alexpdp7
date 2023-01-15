class proxmox {
  file {'/etc/network/interfaces':
    content => epp('proxmox/interfaces', {
      "network" => lookup("network"),
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

  file {'/etc/apt/sources.list.d/pve-enterprise.list':
    ensure => absent,
  }

  file {'/etc/apt/sources.list.d/pve-no-subscription.list':
    content => 'deb http://download.proxmox.com/debian/pve bullseye pve-no-subscription
',
  }
}
