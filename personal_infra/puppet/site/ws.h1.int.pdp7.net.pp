node 'ws.h1.int.pdp7.net' {
  class {'podman':
    user => 'alex',
    storage_driver => 'zfs',
  }

  package {['isync', 'gnutls-utils']:}

  class {'workstation':}
  class {'remote_desktop':}
}
