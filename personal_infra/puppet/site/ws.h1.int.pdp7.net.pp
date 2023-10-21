node 'ws.h1.int.pdp7.net' {
  class {'podman':
    user => 'alex',
    storage_driver => 'zfs',
  }

  package {['pipx', 'isync', 'weechat', 'rclone']:}
}
