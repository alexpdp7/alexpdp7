class podman($user, $storage_driver) {
  package {'podman':}

  file {['/etc/subuid', '/etc/subgid']:
    content => "${user}:100000:65536\n",
  }

  exec {"/usr/bin/sed -i 's/driver = \".*\"/driver = \"${storage_driver}\"/g' /etc/containers/storage.conf":
    require => Package['podman'],
    unless => "/usr/bin/grep 'driver = \"${storage_driver}\"' /etc/containers/storage.conf",
  }

  exec {"/usr/bin/sed -i 's|#mount_program = \"/usr/bin/fuse-overlayfs\"|mount_program = \"/usr/bin/fuse-overlayfs\"|g' /etc/containers/storage.conf":
    require => Package['podman'],
    unless => "/usr/bin/grep '^mount_program = \"/usr/bin/fuse-overlayfs\"' /etc/containers/storage.conf",
  }
}
