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

  service {['rpcbind.target', 'rpcbind.service', 'rpcbind.socket']:
    ensure => stopped,
    enable => mask,
  }
}
